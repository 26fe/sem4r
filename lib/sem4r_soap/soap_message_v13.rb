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
    class SoapMessageV13

      attr_reader :response
      attr_reader :counters

      def initialize(connector, credentials)
        @credentials = credentials
        @connector = connector
        @response = nil
        @counters = {}
      end

      def body=(soap_body_content)
        @soap_body_content = soap_body_content
      end

      def send(service_url, soap_action)
        soap_message = build_soap_message
        response_xml = @connector.send(service_url, soap_action, soap_message)
        # erase namespace 'nsX'so it more simple parsing the xml

        # response_xml = response_xml.gsub(/ns\d:/, "")
        # @response = REXML::Document.new(response_xml)
        response_xml.gsub!(/\b(ns\d:|xsi:|s:|soapenv:|env:|soap:)/, "")
        response_xml.gsub!(/xmlns=["'].*?['"]/, '')
        @response = Nokogiri::XML::Document.parse(response_xml)

        # extract information from header
        #  <soapenv:Header>
        #      <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v13">16</responseTime>
        #      <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v13">5</operations>
        #      <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v13">5</units>
        #      <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v13">abade53d3dbecd45600e7d14563f10f1</requestId>
        #  </soapenv:Header>

        header = @response.xpath("//Header").first
        if header
          @counters = {
            :response_time => header.at_xpath('responseTime').text.to_i,
            :operations => header.at_xpath('operations').text.to_i,
            :units => header.at_xpath('units').text.to_i
          }
        end
      
        # check soap fault
        #<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        # <soapenv:Body>
        #  <soapenv:Fault>
        #   <faultcode>soapenv:Server.generalException</faultcode>
        #   <faultstring>An internal error has occurred.  Please retry your request.</faultstring>
        #   <detail>
        #    <fault xmlns:ns1="https://adwords.google.com/api/adwords/v13">
        #     <code>0</code>
        #     <message>An internal error has occurred.  Please retry your request.</message>
        #    </fault>
        #   </detail>
        #  </soapenv:Fault>
        # </soapenv:Body>
        #</soapenv:Envelope>
        #=======
        fault_el = @response.xpath("//Fault").first
        if fault_el
          fault_code   = fault_el.at_xpath('faultcode').text
          fault_string = fault_el.at_xpath('faultstring').text
          raise SoapError,  "#{fault_code}: '#{fault_string}'"
        end
        self
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

      def build_soap_message
        soap_message = '<?xml version="1.0" encoding="utf-8" ?>'
        soap_message +=<<-EOFS
      <env:Envelope
         xmlns:xsd="http://www.w3.org/2001/XMLSchema"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        EOFS
        soap_message += build_soap_header(@credentials)
        soap_message += "<env:Body>"
        soap_message += @soap_body_content
        soap_message += <<-EOFS
      </env:Body>
    </env:Envelope>
        EOFS
        soap_message
      end
    end

  end # module Soap
end # module Sem4r