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

  class SoapServiceV2010 < SoapService

    def initialize
      super
    end

    def self.soap_call(method, options = {})
      _soap_call("v2010", method, options)
    end

    private

    def build_soap_header(credentials)
      s = if @service_namespace then "s:" else ""  end
      auth_token = credentials.authentication_token

      str = "<env:Header>"
      str += "<#{s}RequestHeader env:mustUnderstand=\"0\">"

      str +="<authToken>#{auth_token}</authToken>"
      str +="<userAgent>#{credentials.useragent}</userAgent>"
      str +="<developerToken>#{credentials.developer_token}</developerToken>"

      if credentials.client_email
        str += "<clientEmail>#{credentials.client_email}</clientEmail>"
      end

      str += "</#{s}RequestHeader>"
      str += "</env:Header>"
      str
    end

    def _send(service_url, soap_action, soap_xml)
      _send_raw(service_url, soap_xml)
    end

    def send_raw(service_url, soap_message)
      soap_message = soap_message.dup
      soap_message.gsub!(/\{authentication_token\}/,      @credentials.authentication_token)
      soap_message.gsub!(/\{useragent\}/,                 @credentials.useragent)
      soap_message.gsub!(/\{developer_token\}/,           @credentials.developer_token)
      # soap_message.gsub!(/{client_email}/,            @credentials.client_email)
      _send_raw(service_url, soap_message)
    end

    def _send_raw(service_url, soap_message)
      response_xml = @connector.send(service_url, "", soap_message)
      soap_response = SoapResponse.new.parse_response(response_xml)
      soap_response
    end
    
  end

end