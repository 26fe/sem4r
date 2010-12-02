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

module Sem4rSoap

  class SoapConnector < HttpConnector
    include SoapDumper

    def initialize
      super
      @logger = nil
    end

    def logger=(log)
      @logger = log
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

      @logger.info("Post to #{uri.path} (#{soap_action})") if @logger
      response = request_post(uri, soap_message, headers)
      unless response
        raise Sem4rError, "Connection Error"
      end
      response_xml = response.body
      dump_soap_request(service_url, soap_message)
      dump_soap_response(service_url, response_xml)
      response_xml
    end
  end

end # module Sem4r
