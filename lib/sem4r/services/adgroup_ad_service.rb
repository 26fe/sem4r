module Sem4r
  class AdgroupAdService
    include DefineCall

    def initialize(connector)
      @connector = connector
      @service_namespace = "https://adwords.google.com/api/adwords/cm/v200909"
      @header_namespace = @service_namespace
      @service_url = "https://adwords-sandbox.google.com/api/adwords/cm/v200909/AdGroupAdService"
    end

    define_call_v2009 :all, :adgrop_id
    define_call_v2009 :create, :xml

    private

    def _all(adgroup_id)
      <<-EOFS
      <get xmlns="#{@service_namespace}">
        <selector>
          <adGroupIds>#{adgroup_id}</adGroupIds>
        </selector>
      </get>
      EOFS
    end

    def _create(xml)
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        <operations xsi:type="AdGroupAdOperation">
          <operator>ADD</operator>
          <operand>
            #{xml}
          </operand>
        </operations>
      </mutate>
      EOFS
    end

  end
end
