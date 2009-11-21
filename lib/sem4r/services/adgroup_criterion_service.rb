module Sem4r
  class AdgroupCriterionService
    include DefineCall

    def initialize(connector)
      @connector = connector
      @service_namespace = "https://adwords.google.com/api/adwords/cm/v200909"
      @header_namespace = @service_namespace
      @service_url = "https://adwords-sandbox.google.com/api/adwords/cm/v200909/AdGroupCriterionService"
    end

    define_call_v2009 :all, :adgroup_id
    define_call_v2009 :create, :adgroup_id, :xml

    private
    
    def _all(adgroup_id)
      <<-EOFS
      <get xmlns="#{@service_namespace}">
        <selector>
          <idFilters>
            <adGroupId>#{adgroup_id}</adGroupId>
          </idFilters>
        </selector>
      </get>
      EOFS
    end

    def _create(adgroup_id, xml)
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operations xsi:type="AdGroupCriterionOperation">
          <operator>ADD</operator>
          <operand xsi:type="BiddableAdGroupCriterion">
            <adGroupId>#{adgroup_id}</adGroupId>            
            #{xml}
           </operand>
        </operations>
      </mutate>
      EOFS
    end
  end
end
