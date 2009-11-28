# -------------------------------------------------------------------
# Copyright (c) 2009 Sem4r sem4ruby@gmail.com
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

  class SoapConnector

    MAXRETRIES = 3

    def initialize
      @sessions = {}
      @logger = nil
      @soap_log = nil
    end

    def logger=(log)
      @logger = log
    end

    def dump_soap_to( file )
      @soap_log = file
    end

    def authentication_token(email, password)

      str = "accountType=GOOGLE&Email=#{email}&Passwd=#{password}&service=adwords"
      str = URI.escape(str)

      base_url = "https://www.google.com"
      sess = get_sess_for_host(base_url)
      retries = 0; resp = nil
      while retries <= MAXRETRIES and resp.nil?
        begin
          retries += 1
          resp = sess.post("/accounts/ClientLogin", str,
            {"Content-Type" => "application/x-www-form-urlencoded"})
        rescue Patron::Error => e
          @logger.warn("authentication retries!!! #{e.to_s}") if @logger
          invalidate_sess(base_url)
          sleep(2 * retries) # wait 1 sec
          sess = get_sess_for_host(base_url)
        end
      end
      unless resp
        raise "Connection Error, Network is down?? :-((("
      end

      if resp.status < 400
        # puts resp.body
        hash = {}
        resp.body.split("\n").each do |line|
          key, value = line.split("=")
          hash[key.strip] = value.strip
        end
        return hash['Auth']

        # if response.code == '200'
        #   return response.body[/Auth=(.*)/, 1]

      end

      # sess.post("/foo/stuff", "some data", {"Content-Type" => "text/plain"})
    end


    def message_v2009(credentials, header_namespace, service_namespace)
      message = SoapMessageV2009.new(self)
      message.init( credentials, header_namespace, service_namespace )
      message
    end

    def message_v13(credentials)
      message = SoapMessageV13.new(self)
      message.init( credentials )
      message
    end

    def send(service_url, soap_action, soap_message)
      begin
        uri = URI.parse(service_url)
      rescue URI::InvalidURIError
        puts "Invalid url --  #{service_url}"
        raise
      end
      base_url = uri.scheme + "://" + uri.host

      headers = {
        "Content-Type" => "text/xml; charset=utf-8",
        "Content-Length" => soap_message.length.to_s,
        "SOAPAction" => soap_action}

      retries = 0; resp = nil
      sess = get_sess_for_host(base_url)
      while retries <= MAXRETRIES and resp.nil?
        begin
          retries += 1
          @logger.info("Post to #{uri.path} (#{soap_action})") if @logger
          resp = sess.post(uri.path, soap_message, headers)
        rescue Patron::Error => e
          @logger.warn("soap_connector.send retries!!! #{e.to_s}") if @logger
          invalidate_sess(base_url)
          sleep(2 * retries) # wait 1 sec
          sess = get_sess_for_host(base_url)
        end
      end
      unless resp
        raise "Connection Error"
      end

      response_xml = resp.body

      if @soap_log
        @soap_log.puts "<!-- Post to '#{service_url}' -->"
        @soap_log.puts soap_message
        # puts "--------------"
        # pp resp
        # puts resp.body
        # request = REXML::Document.new(@soap_message)
        # f = REXML::Formatters::Pretty.new
        # f.write(request, $stdout)
        # puts
        @soap_log.puts "<!--  -->"
        @soap_log.puts response_xml

        # response = REXML::Document.new(resp.body)
        # f = REXML::Formatters::Pretty.new
        # f.write(response, $stdout)
        @soap_log.puts "<!--  -->"
        @soap_log.flush
      end
      response_xml
    end

    def download(url, path_name)
      uri = URI.parse(url)
      base_url = uri.scheme + "://" + uri.host
      sess = get_sess_for_host(base_url)
      sess.get_file(uri.path, path_name)
    end

    private




    def get_sess_for_host(base_url)
      sess = @sessions[base_url]
      unless sess
        sess = Patron::Session.new
        # sess.connect_timeout = 3000 #millis
        sess.timeout = 12
        sess.base_url = base_url
        sess.headers['User-Agent'] = 'ruby'
        @sessions[base_url] = sess
      end
      sess
    end

    def invalidate_sess(base_url)
      sess = @sessions[base_url]
      if sess
        # sess.close
        @sessions[base_url] = nil
      end
    end

  end

end
