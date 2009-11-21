module Sem4r
  class AdgroupService
    include DefineCall

    def initialize(connector)
      @connector = connector
      @service_namespace = "https://adwords.google.com/api/adwords/cm/v200909"
      @header_namespace = @service_namespace
      @service_url = "https://adwords-sandbox.google.com/api/adwords/cm/v200909/AdGroupService"
    end

    define_call_v2009 :all, :campaign_id
    define_call_v2009 :create, :xml
    define_call_v2009 :delete, :adgroup_id

    def _all(campaign_id)
      <<-EOFS
      <get xmlns="#{@service_namespace}">
        <selector>
          <campaignId>#{campaign_id}</campaignId>
        </selector>
      </get>
      EOFS
    end

    def _create( xml )
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operations xsi:type="AdGroupOperation">
          <operator>ADD</operator>
          <operand>
            #{xml}
          </operand>
        </operations>
      </mutate>
      EOFS
    end

    def _delete( id )
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operations xsi:type="AdGroupOperation">
          <operator>SET</operator>
          <operand>
            <id>#{id}</id>
            <status>DELETED</status>
          </operand>
        </operations>
      </mutate>
      EOFS

      #
      # raise  [OperatorError.OPERATOR_NOT_SUPPORTED @ operations[0]] 
      #

      #      <<-EOFS
      #      <mutate xmlns="#{@service_namespace}">
      #        <operations xsi:type="AdGroupOperation">
      #          <operator>REMOVE</operator>
      #          <operand>
      #            <id>#{id}</id>
      #          </operand>
      #        </operations>
      #      </mutate>
      #      EOFS
    end

  end
end
