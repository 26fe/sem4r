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

module Sem4r
  class BulkMutateJobService
    include SoapCall

    def initialize(connector)
      @connector = connector

      @service_namespace = "https://adwords.google.com/api/adwords/cm/v200909"
      @header_namespace = @service_namespace

      @sandbox_service_url    = "https://adwords-sandbox.google.com/api/adwords/job/v200909/BulkMutateJobService"
      @production_service_url = "https://adwords.google.com/api/adwords/job/v200909/BulkMutateJobService"
    end

    soap_call_v2009 :all, :selector
    soap_call_v2009 :mutate, :job_operation

    private

    def _all(selector)
      "<get xmlns=\"#{@service_namespace}\">" + selector.to_xml +  '</get>';
    end

    def _mutate(job_operation)
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operation xsi:type="JobOperation">
        #{job_operation.to_xml}
        </operation>
      </mutate>
      EOFS

      #      <<-EOFS
      #      <mutate xmlns="https://adwords.google.com/api/adwords/cm/v200909">
      #        <operation xsi:type="JobOperation">
      #          <operator>ADD</operator>
      #          <operand xsi:type="BulkMutateJob">
      #
      #            <request>
      #              <partIndex>0</partIndex>
      #              <operationStreams>
      #
      #                <scopingEntityId>
      #                  <type>CAMPAIGN_ID</type>
      #                  <value>#{campaign_id}</value>
      #                </scopingEntityId>
      #
      #                <operations xsi:type="AdGroupAdOperation">
      #                  <operator>ADD</operator>
      #                  <operand>
      #                    <adGroupId>#{adgroup_id}</adGroupId>
      #                    <ad xsi:type="TextAd">
      #                      <headline>Cruise to Mars Sector 1</headline>
      #                      <description1>Visit the Red Planet in style.</description1>
      #                      <description2>Low-gravity fun for everyone!</description2>
      #                      <url>http://www.example.com</url>
      #                      <displayUrl>www.example.com</displayUrl>
      #                    </ad>
      #                    <status>ENABLED</status>
      #                  </operand>
      #                </operations>
      #
      #                <operations xsi:type="AdGroupAdOperation">
      #                  <operator>ADD</operator>
      #                  <operand>
      #                    <adGroupId>#{adgroup_id}</adGroupId>
      #                    <ad xsi:type="TextAd">
      #                      <url>http://www.example.com</url>
      #                      <displayUrl>www.example.com</displayUrl>
      #                      <headline>Cruise to Mars Sector 10</headline>
      #                      <description1>Visit the Red Planet in style.</description1>
      #                      <description2>Low-gravity fun for everyone!</description2>
      #                    </ad>
      #                    <status>ENABLED</status>
      #                  </operand>
      #                </operations>
      #
      #              </operationStreams>
      #            </request>
      #
      #            <numRequestParts>1</numRequestParts>
      #          </operand>
      #        </operation>
      #      </mutate>
      #      EOFS
    end

  end
end
