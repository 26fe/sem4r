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

  class SoapMessageV13 < SoapMessage

    attr_reader :response
    attr_reader :counters

    def initialize(connector, credentials)
      @credentials = credentials
      @connector = connector
      @response = nil
      @counters = {}
      @soap_header_namespaces = {}
    end

    def body=(soap_body_content)
      @soap_body_content = soap_body_content
    end

    def send(service_url, soap_action)
      soap_message = build_soap_message
      response_xml = @connector.send(service_url, soap_action, soap_message)
      parse_response(response_xml)
    end

    private

    def build_soap_header(credentials)
      str= <<-EOFS
      <env:Header>
        <email env:mustUnderstand="0">#{credentials.email}</email>
        <password env:mustUnderstand="0">#{credentials.password}</password>
      EOFS

      if credentials.client_email
        str += "<clientEmail env:mustUnderstand=\"0\">#{credentials.client_email}</clientEmail>"
      end

      str += <<-EOFS
        <useragent env:mustUnderstand="0">#{credentials.useragent}</useragent>
        <developerToken env:mustUnderstand="0">#{credentials.developer_token}</developerToken>
      </env:Header>
      EOFS
      str
    end

  end

end # module Sem4r