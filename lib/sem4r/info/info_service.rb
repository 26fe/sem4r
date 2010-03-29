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

#  <env:Body>
#    <n3:get xmlns:n3="https://adwords.google.com/api/adwords/info/v200909">
#      <n3:selector>
#        <n3:dateRange xmlns:n4="https://adwords.google.com/api/adwords/cm/v200909">
#          <n4:min>20090101</n4:min>
#          <n4:max>20091030</n4:max>
#        </n3:dateRange>
#        <n3:apiUsageType>UNIT_COUNT</n3:apiUsageType>
#      </n3:selector>
#    </n3:get>
#  </env:Body>
#</env:Envelope>


module Sem4r
  class InfoService
    include SoapCall

    def initialize(connector)
      @connector = connector
      @header_namespace  = "https://adwords.google.com/api/adwords/cm/v200909"
      @service_namespace = "https://adwords.google.com/api/adwords/info/v200909"

      @production_service_url = "https://adwords.google.com/api/adwords/info/v200909/InfoService"
      @sandbox_service_url    = "https://adwords-sandbox.google.com/api/adwords/info/v200909/InfoService"
    end


    soap_call_v2009 :unit_cost

    def _unit_cost( usage_type )
      <<-EOFS
      <s:get>
        <s:selector>
          <s:dateRange>
            <min>20090101</min>
            <max>20091105</max>
          </s:dateRange>
          <s:apiUsageType>#{usage_type}</s:apiUsageType>
        </s:selector>
      </s:get>
      EOFS
    end


    # Total units used since the beginning of the year: 0
    #    def old_unit_cost(credentials)
    #
    #      soap_message = @connector.message_v2009(credentials, @header_namespace, @service_namespace )
    #      soap_message.body = "soap_body_content"
    #
    #
    #      soap_message.instance_eval do
    #        def build_soap_message
    #          str = <<-EOFS
    #<?xml version="1.0" encoding="utf-8" ?>
    #  <env:Envelope
    #    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    #    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    #    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    #    xmlns="https://adwords.google.com/api/adwords/cm/v200909"
    #    xmlns:s="https://adwords.google.com/api/adwords/info/v200909">
    #    <env:Header>
    #      <s:RequestHeader env:mustUnderstand="0">
    #        <authToken>#{@credentials.authentication_token}</authToken>
    #        <userAgent>adwords4r: Sample User Agent</userAgent>
    #        <developerToken>#{@credentials.developer_token}</developerToken>
    #      </s:RequestHeader>
    #    </env:Header>
    #    <env:Body  >
    #      <s:get>
    #        <s:selector>
    #          <s:dateRange>
    #            <min>20090101</min>
    #            <max>20091105</max>
    #          </s:dateRange>
    #          <s:apiUsageType>UNIT_COUNT</s:apiUsageType>
    #        </s:selector>
    #      </s:get>
    #    </env:Body>
    #  </env:Envelope>
    #EOFS
    #          str
    #        end
    #      end
    #
    #      result_xml = soap_message.send(@sandbox_service_url)
    #      result_xml
    #    end

  end
end
