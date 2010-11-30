# -*- coding: utf-8 -*-
# -------------------------------------------------------------------
# Copyright (c) 2009-2010 Sem4r sem4ruby@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# -------------------------------------------------------------------

module Sem4r
  module Soap

    class SoapConnector < HttpConnector
      include SoapDumper

      MAXRETRIES = 3

      def initialize
        super
        @logger = nil
      end

      def logger=(log)
        @logger = log
      end

      def authentication_token(email, password)
        str = "accountType=GOOGLE&Email=#{email}&Passwd=#{password}&service=adwords"
        str = URI.escape(str)

        uri = URI.parse( "https://www.google.com/accounts/ClientLogin" )
        sess = get_sess_for_host(uri)
        retries = 0; response = nil
        while retries <= MAXRETRIES and response.nil?
          retries += 1

          headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
        
          #########################
          if UsePatron
            begin
              e = nil
              response = sess.post( uri.path, str, headers )
              status = response.status
            rescue Patron::Error => e
            end
          else
            response = sess.request_post(uri.path, str, headers )
            # pp response.methods
            # pp response.class.to_s
            status = response.code.to_i
            # pp "status: #{status}"
          end
          ##########################

          if e
            @logger.warn("authentication retries!!! #{e.to_s}") if @logger
            invalidate_sess(uri)
            sleep(2 * retries) # wait 1 sec
            sess = get_sess_for_host(uri)
          end
        end
        unless response
          raise "Connection Error, Network is down?? :-((("
        end
      
        if status == 200
          return response.body[/Auth=(.*)/, 1]
        end
        raise Sem4rError, "authentication failed status is #{status}"
      end

      def send(service_url, soap_action, soap_message)
        begin
          uri = URI.parse(service_url)
        rescue URI::InvalidURIError
          puts "Invalid url --  #{service_url}"
          raise
        end

        headers = {
          "Content-Type" => "text/xml; charset=utf-8",
          "Content-Length" => soap_message.length.to_s,
          "SOAPAction" => soap_action}

        retries = 0; response = nil
        sess = get_sess_for_host(uri)
        while retries <= MAXRETRIES and response.nil?
          retries += 1
          @logger.info("Post to #{uri.path} (#{soap_action})") if @logger

          ############################
          if UsePatron
            begin
              e = nil
              response = sess.post(uri.path, soap_message, headers)
            rescue Patron::Error => e
            end
          else
            begin
              response = sess.request_post(uri.path, soap_message, headers)
            rescue
              raise
            end
          end
          ##############################

          if e
            @logger.warn("soap_connector.send retries!!! #{e.to_s}") if @logger
            invalidate_sess(uri)
            sleep(2 * retries) # wait 1 sec
            sess = get_sess_for_host(uri)
          end
        end
        unless response
          raise Sem4rError, "Connection Error"
        end

        response_xml = response.body
        dump_soap_request(service_url, soap_message)
        dump_soap_response(service_url, response_xml)
        response_xml
      end
    end

  end # module Soap
end # module Sem4r
