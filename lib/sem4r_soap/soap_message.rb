# -*- coding: utf-8 -*-
# -------------------------------------------------------------------------
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
# 
# -------------------------------------------------------------------------

module Sem4rSoap
  class SoapMessage

    def initialize
      @soap_header_namespaces = {}
    end
    #
    #    v13
    #
    #    def build_soap_message
    #      soap_message = '<?xml version="1.0" encoding="utf-8" ?>'
    #      soap_message +=<<-EOFS
    #      <env:Envelope
    #         xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    #         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    #         xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
    #      EOFS
    #      soap_message += build_soap_header(@credentials)
    #      soap_message += "<env:Body>"
    #      soap_message += @soap_body_content
    #      soap_message += <<-EOFS
    #      </env:Body>
    #    </env:Envelope>
    #      EOFS
    #      soap_message
    #    end

    def build_soap_message
      soap_message = '<?xml version="1.0" encoding="utf-8" ?>'
      soap_message +=<<-EOFS
      <env:Envelope
         xmlns:xsd="http://www.w3.org/2001/XMLSchema"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
      EOFS

      @soap_header_namespaces.each do |name, value|
        soap_message += " #{name}=\"#{value}\""
      end
      soap_message += ">"

      soap_message += build_soap_header(@credentials)
      soap_message += "<env:Body>"
      soap_message += @soap_body_content
      soap_message += <<-EOFS
      </env:Body>
    </env:Envelope>
      EOFS
      soap_message
    end

    def parse_response(response_xml)
      # erase namespace so it more simple parsing the xml
      response_xml.gsub!(/\b(ns\d:|xsi:|s:|soapenv:|env:|soap:)/, "")
      response_xml.gsub!(/xmlns=["'].*?['"]/, '')
      @response = Nokogiri::XML::Document.parse(response_xml)

      #
      # extract information from header
      #
      header = @response.at_xpath("/Envelope/Header/ResponseHeader")   # v2010xx
      if header
        @counters = {
          :operations    => header.at_xpath("operations").text.to_i,
          :response_time => header.at_xpath("responseTime").text.to_i,
          :units         => header.at_xpath("units").text.to_i
        }
      else
        header = @response.at_xpath("/Envelope/Header")   # v13
        if header
          @counters = {
            :operations    => header.at_xpath("operations").text.to_i,
            :response_time => header.at_xpath("responseTime").text.to_i,
            :units         => header.at_xpath("units").text.to_i
          }
        end
      end
      #
      # check soap fault
      #
      fault_el = @response.at_xpath("//Fault")
      if fault_el
        # fault_code   = fault_el.at_xpath('faultcode').text
        # fault_string = fault_el.at_xpath('faultstring').text
        # raise SoapError,  "#{fault_code}: '#{fault_string}'"

        fault_string = fault_el.at_xpath('faultstring').text
        @logger.error("soap error: #{fault_string}") if @logger
        raise fault_string
      end
      self
    end

  end
end
