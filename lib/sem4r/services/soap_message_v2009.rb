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

  class SoapMessageV2009

    attr_reader :response
    attr_reader :counters
    
    def initialize(connector)
      @connector = connector
      @response = nil
      @counters = {}
      @logger = nil
    end

    def logger=(logger)
      @logger= logger
    end

    def init(credentials, header_namespace, service_namespace)
      @credentials = credentials
      @header_namespace = header_namespace
      @service_namespace = service_namespace
    end

    def body=(soap_body_content)
      @soap_body_content = soap_body_content
    end

    def send(service_url)
      soap_message = build_soap_message
      response_xml = @connector.send(service_url, "", soap_message)
      # erase namespace so it more simple parsing the xml
      response_xml = response_xml.gsub(/ns\d:/, "")
      @response = REXML::Document.new(response_xml)

      #
      # extract information from header
      #
      header = REXML::XPath.first(@response, "//ResponseHeader")
      if header
        @counters = {
          :operations    => header.elements['operations'].text.to_i,
          :response_time => header.elements['responseTime'].text.to_i,
          :units         => header.elements['units'].text.to_i
        }
      end

      #
      # check soap fault
      #
      fault_el = REXML::XPath.first(@response, "//soap:Fault")
      if fault_el
        fault_string = fault_el.elements['faultstring'].text
        @logger.error("soap error: #{fault_string}") if @logger
        raise fault_string
      end
      self

      #  <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      #    <soap:Header>
      #        <ResponseHeader xmlns="https://adwords.google.com/api/adwords/cm/v200909">
      #            <requestId>e7c3b00f339bcaf56b7df47db97efdb7</requestId>
      #            <operations>1</operations>
      #            <responseTime>231</responseTime>
      #            <units>1</units>
      #        </ResponseHeader>
      #    </soap:Header>
      #    <soap:Body>
      #        <soap:Fault>
      #            <faultcode>soap:Server</faultcode>
      #            <faultstring>[CampaignError.DUPLICATE_CAMPAIGN_NAME @ operations[0].operand.name]</faultstring>
      #            <detail>
      #                <ApiExceptionFault xmlns="https://adwords.google.com/api/adwords/cm/v200909">
      #                    <message>[CampaignError.DUPLICATE_CAMPAIGN_NAME @ operations[0].operand.name]</message>
      #                    <ApplicationException.Type>ApiException</ApplicationException.Type>
      #                    <errors xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CampaignError">
      #                        <fieldPath>operations[0].operand.name</fieldPath>
      #                        <trigger></trigger>
      #                        <ApiError.Type>CampaignError</ApiError.Type>
      #                        <reason>DUPLICATE_CAMPAIGN_NAME</reason>
      #                    </errors>
      #                </ApiExceptionFault>
      #            </detail>
      #        </soap:Fault>
      #    </soap:Body>
      #</soap:Envelope>
    end

    private

    def build_soap_header
      auth_token = @credentials.authentication_token

      str = "<env:Header>"

      if @service_namespace
        str += "<s:RequestHeader env:mustUnderstand=\"0\">"
      else
        str += "<RequestHeader env:mustUnderstand=\"0\">"
      end

      str +=<<-EOFS
          <authToken>#{auth_token}</authToken>
          <userAgent>#{@credentials.useragent}</userAgent>
          <applicationToken>IGNORED</applicationToken>
          <developerToken>#{@credentials.developer_token}</developerToken>
      EOFS

      if @credentials.client_email
        str += "<clientEmail>#{@credentials.client_email}</clientEmail>"
      end
      
      if @service_namespace
        str += "</s:RequestHeader>"
      else
        str += "</RequestHeader>"
      end
      str += "</env:Header>"
      str
    end

    def build_soap_message
      soap_message = '<?xml version="1.0" encoding="utf-8" ?>'
      soap_message +=<<-EOFS
      <env:Envelope
         xmlns:xsd="http://www.w3.org/2001/XMLSchema"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
         xmlns="#{@header_namespace}"
      EOFS

      if @service_namespace
        soap_message += " xmlns:s=\"#{@service_namespace}\""
      end
      soap_message += ">"

      soap_message += build_soap_header
      soap_message += "<env:Body>"
      soap_message += @soap_body_content
      soap_message += <<-EOFS
      </env:Body>
    </env:Envelope>
      EOFS
      soap_message
    end

  end

end
