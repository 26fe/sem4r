# -------------------------------------------------------------------
# Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
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

    def initialize(connector)
      @connector = connector
      @service_namespace = "https://adwords.google.com/api/adwords/info/v200909"
      @header_namespace = "https://adwords.google.com/api/adwords/cm/v200909"

      @sandbox_service_url = "https://adwords-sandbox.google.com/api/adwords/info/v200909/InfoService"
    end

    # Total units used since the beginning of the year: 0
    def unit_count(credentials)
      soap_body_content = <<-EOFS
        <get xmlns="#{@service_namespace}">
          <selector>
            <dateRange xmlns="https://adwords.google.com/api/adwords/cm/v200909">
              <min>20090101</min>
              <max>20091030</max>
            </dateRange>
            <apiUsageType>UNIT_COUNT</apiUsageType>
          </selector>
        </get>
      EOFS


      str = <<-EOFS
      <?xml version="1.0" encoding="utf-8" ?>
  <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
    <env:Header>
      <n1:RequestHeader env:mustUnderstand="0"
            xmlns:n1="https://adwords.google.com/api/adwords/info/v200909"
            xmlns:n2="https://adwords.google.com/api/adwords/cm/v200909">
        <n2:authToken></n2:authToken>
        <n2:userAgent>adwords4r: Sample User Agent</n2:userAgent>
        <n2:applicationToken>IGNORED</n2:applicationToken>
        <n2:developerToken></n2:developerToken>
      </n1:RequestHeader>
    </env:Header>
    <env:Body>
      <n3:get xmlns:n3="https://adwords.google.com/api/adwords/info/v200909">
        <n3:selector>
          <n3:dateRange xmlns:n4="https://adwords.google.com/api/adwords/cm/v200909">
            <n4:min>20090101</n4:min>
            <n4:max>20091105</n4:max>
          </n3:dateRange>
          <n3:apiUsageType>UNIT_COUNT</n3:apiUsageType>
        </n3:selector>
      </n3:get>
    </env:Body>
  </env:Envelope>
EOFS

      soap_message = @connector.message_v2009(credentials, @header_namespace )
      soap_message.body = soap_body_content


      soap_message.instance_eval do
        def build_soap_message
          str = <<-EOFS
<?xml version="1.0" encoding="utf-8" ?>
  <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
    <env:Header>
      <n1:RequestHeader env:mustUnderstand="0"
            xmlns:n1="https://adwords.google.com/api/adwords/info/v200909"
            xmlns:n2="https://adwords.google.com/api/adwords/cm/v200909">
        <n2:authToken></n2:authToken>
        <n2:userAgent>adwords4r: Sample User Agent</n2:userAgent>
        <n2:applicationToken>IGNORED</n2:applicationToken>
        <n2:developerToken></n2:developerToken>
      </n1:RequestHeader>
    </env:Header>
    <env:Body>
      <n3:get xmlns:n3="https://adwords.google.com/api/adwords/info/v200909">
        <n3:selector>
          <n3:dateRange xmlns:n4="https://adwords.google.com/api/adwords/cm/v200909">
            <n4:min>20090101</n4:min>
            <n4:max>20091105</n4:max>
          </n3:dateRange>
          <n3:apiUsageType>UNIT_COUNT</n3:apiUsageType>
        </n3:selector>
      </n3:get>
    </env:Body>
  </env:Envelope>
EOFS
          str
        end
      end

      result_xml = soap_message.send(@service_url)
      result_xml
    end

  end
end
