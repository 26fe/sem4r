module Sem4r

  class CampaignService
    include DefineCall

    def initialize(connector)
      @connector = connector
      @service_namespace = "https://adwords.google.com/api/adwords/cm/v200909"
      @header_namespace = @service_namespace
      @service_url = "https://adwords-sandbox.google.com/api/adwords/cm/v200909/CampaignService"
    end

    define_call_v2009 :all
    define_call_v2009 :create, :xml
    define_call_v2009 :delete, :id

    private

    def _all(statuses = [Campaign::ACTIVE, Campaign::PAUSED])
      str = <<-EOFS
      <get xmlns="#{@service_namespace}">
        <selector>
      EOFS
      statuses.each do |s|
        str += "<campaignStatuses>#{s}</campaignStatuses>"
      end
      str += <<-EOFS
          <statsSelector>
            <dateRange>
              <min>20090101</min>
              <max>20091231</max>
            </dateRange>
          </statsSelector>
        </selector>
      </get>
      EOFS
    end

    def _create(xml)
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operations xsi:type="CampaignOperation">
          <operator>ADD</operator>
          <operand>
            #{xml}
          </operand>
        </operations>
      </mutate>
      EOFS
    end

    def _delete(id)
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operations xsi:type="CampaignOperation">
          <operator>SET</operator>
          <operand>
            <id>#{id}</id>
            <status>DELETED</status>
          </operand>
        </operations>
      </mutate>
      EOFS
    end

  end
end
