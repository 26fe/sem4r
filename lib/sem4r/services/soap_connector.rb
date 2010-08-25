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

  class HttpConnector
    begin
      require 'patron'
      UsePatron = false
      # $stderr.puts "Using patron gems"
    rescue LoadError
      UsePatron = false
      # $stderr.puts "Patron not found, degrade to net/https"
    end

    if !UsePatron
      require 'net/https'
      require 'uri'
      # $stderr.puts "Using standard net/https"
    end

    def get_sess_for_host(uri)
      @sessions ||= {}

      if UsePatron
        url = uri.scheme + "://" + uri.host
        sess = @sessions[url]
        unless sess
          sess = Patron::Session.new
          # sess.connect_timeout = 3000 #millis
          sess.timeout = 12
          sess.base_url = url
          sess.headers['User-Agent'] = 'ruby'
          @sessions[url] = sess
        end
        sess
      else
        url = uri.scheme + "://" + uri.host
        sess = @sessions[url]
        unless sess
          sess = Net::HTTP.new(uri.host, uri.port)
          sess.use_ssl = (uri.scheme == "https")
          @sessions[url] = sess
        end
        sess
      end
    end

    def invalidate_sess(uri)
      sess = @sessions[uri.host]
      if sess
        # sess.close
        @sessions[uri.host] = nil
      end
    end

    def download(url, path_name)

      if UsePatron
        uri = URI.parse(url)
        sess = get_sess_for_host(uri)
        sess.get_file(uri.path, path_name)
      else
        require 'open-uri'
        data = open(url){ |f| f.read }
        File.open(path_name, "w") { |f| f.write(data) }
      end

    end
  end

  module SoapDumper

    def initialize
      @soap_dump = false
      @soap_dump_log = nil
    end

    def dump_soap_options( dump_options )
      @soap_dump = true
      @soap_dump_log = nil

      if dump_options[:directory]
        @soap_dump_dir = dump_options[:directory]
      else
        @soap_dump_log = File.open( dump_options[:file], "w" )
      end
      @soap_dump_format = false || dump_options[:format]
    end

    def dump_soap(service_url, request_xml, response_xml)
      return unless @soap_dump

      %w{email password developerToken authToken clientEmail}.each do |tag|
        request_xml = request_xml.gsub(/<#{tag}([^>]*)>.*<\/#{tag}>/, "<#{tag}\\1>***censured***</#{tag}>")
      end
      response_xml.gsub(/<email[^>]*>.+<\/email>/, "<email>**censured**</email>")

      str =""
      str << "<!-- Post to '#{service_url}' -->\n"

      if !@soap_dump_format
        str <<  request_xml
      else
        request_xml.gsub!(/\b(ns\d:|xsi:|s:|soapenv:|env:|soap:)/, "")
        request_xml.gsub!(/xmlns=["'].*?['"]/, '')
        xml_document = Nokogiri::XML::Document.parse(request_xml)
        f = REXML::Formatters::Pretty.new
        out = String.new
        f.write(xml_document, out)
        str << out
      end
      str << "\n"

      str <<  "<!-- response -->\n"
      if !@soap_dump_format
        str <<  response_xml
      else
        response_xml.gsub!(/\b(ns\d:|xsi:|s:|soapenv:|env:|soap:)/, "")
        response_xml.gsub!(/xmlns=["'].*?['"]/, '')
        xml_document = Nokogiri::XML::Document.parse(response_xml)
        f = REXML::Formatters::Pretty.new
        out = String.new
        f.write(xml_document, out)
        str << out
      end
      str << "\n"
      str <<  "<!-- end -->"

      if @soap_dump_dir
        service = service_url.match(/\/([^\/]*)$/)[1]
        filename = Time.now.strftime "%Y%m%d-%H%M%S-%L-#{service}.log.xml"

        if not File.directory?(@soap_dump_dir)
          FileUtils.mkdir_p(@soap_dump_dir)
        end

        pathname = File.join(@soap_dump_dir, filename)
        File.open(pathname, "w") {|f|
          f.puts str
        }
      else
        @soap_dump_log.puts str
        @soap_dump_log.flush
      end
    end

  end

  #################

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
      dump_soap(service_url, soap_message, response_xml)
      response_xml
    end

    private

    
  end

end
