module Sem4r
  class AdgroupAd < Base
    #
    # AdGroupAd.Status
    #
    enum :Statuses, [
      :ENABLED,
      :PAUSED,
      :DISABLED
    ]

    #
    # Ad.type
    #
    enum :Types, [
      :DeprecatedAd,
      :MobileAd,
      :TextAd,
      :MobileImageAd,
      :ImageAd,
      :LocalBusinessAd,
      :TemplateAd
    ]

    attr_reader :id
    attr_reader :adgroup

    def initialize(adgroup, &block)
      super( adgroup.adwords, adgroup.credentials )
      @adgroup = adgroup
      instance_eval(&block) if block_given?
    end

    def to_s
      "#{@id} #{@textad[:url]}"
    end

    def to_xml
      <<-EOFS
        <adGroupId>#{adgroup.id}</adGroupId>
        <ad xsi:type="TextAd">
          <url>#{url}</url>
          <displayUrl>#{display_url}</displayUrl>
          <headline>#{headline}</headline>
          <description1>#{description1}</description1>
          <description2>#{description2}</description2>
        </ad>
        <status>ENABLED</status>
      EOFS
    end

    ###########################################################################

    def type=(value)
      @type=value
    end

    def type(value = nil)
      value ? self.type = value : @type
    end

    def url=(value)
      @url=value
    end

    def url(value = nil)
      value ? self.url = value : @url
    end

    def display_url=(value)
      @display_url=value
    end

    def display_url(value = nil)
      value ? self.display_url = value : @display_url
    end

    def headline=(value)
      @headline=value
    end

    def headline(value = nil)
      value ? self.headline = value : @headline
    end

    def description1=(value)
      @description1=value
    end

    def description1(value = nil)
      value ? self.description1 = value : @description1
    end

    def description2=(value)
      @description2=value
    end

    def description2(value = nil)
      value ? self.description2 = value : @description2
    end

    ###########################################################################


    #<entries>
    #    <adGroupId>5000010565</adGroupId>
    #    <ad xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="TextAd">
    #        <id>9998</id>
    #        <url>http://www.pluto.com</url>
    #        <displayUrl>www.Pluto.com</displayUrl>
    #        <approvalStatus>UNCHECKED</approvalStatus>
    #        <Ad.Type>TextAd</Ad.Type>
    #        <headline>Vieni da noi</headline>
    #        <description1>vieni da noi</description1>
    #        <description2>arivieni da noi</description2>
    #    </ad>
    #    <status>ENABLED</status>
    #    <stats>
    #        <network>SEARCH</network>
    #        <Stats.Type>AdStats</Stats.Type>
    #        <percentServed>0.0</percentServed>
    #    </stats>
    #</entries>
    
    def self.from_element(adgroup, el)
      new(adgroup) do
        @id         = el.elements["id"].text
        type          el.elements["Ad.Type"].text
        url           el.elements["url"].text
        display_url   el.elements["displayUrl"].text
        headline      el.elements["headline"].text
        description1  el.elements["description1"].text
        description2  el.elements["description2"].text
      end
    end

    def self.create(adgroup, &block)
      new(adgroup, &block).save
    end

    ############################################################################
    
    def save
      soap_message = service.adgroup_ad.create(credentials, to_xml)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
      id = REXML::XPath.match( rval, "value/ad/id" ).first
      @id = id.text
      self
    end

  end
end
