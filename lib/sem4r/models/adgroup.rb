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
  class Adgroup < Base

    #
    # enum AdGroup.Status
    #
    enum :Statuses, [
      :ENABLED,
      :PAUSED,
      :DELETED
    ]

    attr_reader :id
    attr_reader :campaign
    
    def initialize(campaign, &block)
      super( campaign.adwords, campaign.credentials )
      @campaign = campaign
      @id = nil
      @criterions = nil
      if block_given?
        instance_eval(&block)
        save
      end
    end

    def to_s
      "#{@id} '#{@name}' (#{@status}) - #{@bid}"
    end

    def to_xml
      <<-EOFS
        <campaignId>#{campaign.id}</campaignId>
        <name>#{name}</name>
        <status>ENABLED</status>
        <bids xsi:type="ManualCPCAdGroupBids">
          <keywordMaxCpc>
            <amount xsi:type="Money">
              <microAmount>10000000</microAmount>
            </amount>
          </keywordMaxCpc>
        </bids>
      EOFS
    end

    def empty?
      criterions.empty?
    end

    ###########################################################################

    def name=(value)
      @name=value
    end

    def name(value = nil)
      value ? self.name = value : @name
    end

    def status=(value)
      @status=value
    end

    def status(value = nil)
      value ? self.status = value : @status
    end

    def bid(el)
      @bid = AdgroupBid.from_element(el)
    end

    ###########################################################################

    #  <entries>
    #      <id>5000010559</id>
    #      <campaignId>5522</campaignId>
    #      <campaignName>campaign 2009-11-14 16:41:23 +0100</campaignName>
    #      <name>adgroup 2009-11-14 16:41:30 +0100</name>
    #      <status>ENABLED</status>
    #      <bids xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ManualCPCAdGroupBids">
    #          <AdGroupBids.Type>ManualCPCAdGroupBids</AdGroupBids.Type>
    #          <keywordMaxCpc>
    #              <amount>
    #                  <ComparableValue.Type>Money</ComparableValue.Type>
    #                  <microAmount>10000000</microAmount>
    #              </amount>
    #          </keywordMaxCpc>
    #      </bids>
    #      <stats>
    #          <network>ALL</network>
    #          <Stats.Type>Stats</Stats.Type>
    #      </stats>
    #  </entries>

    def self.from_element(campaign, el)
      new(campaign) do
        @id          = el.elements["id"].text
        name           el.elements["name"].text
        status         el.elements["status"].text
        bid            el.elements["bids"]
      end
    end

    def self.create(campaign, &block)
      new(campaign, &block).save
    end

    ###########################################################################

    def save
      unless @id
        soap_message = service.adgroup.create(credentials, to_xml)
        add_counters( soap_message.counters )
        rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
        id = REXML::XPath.match( rval, "value/id" ).first
        @id = id.text
      end
      # @criterions.each { |criterion| criterion.save }
      self
    end

    def delete
      soap_message = service.adgroup.delete(credentials, @id)
      add_counters( soap_message.counters )
      @id = -1 # logical delete
    end

    ###########################################################################

    def ad(&block)
      save
      ad = AdgroupAd.new(self, &block)
      @ads ||= []
      @ads.push(ad)
      ad
    end

    def ads(refresh = false)
      _ads unless @ads and !refresh
      @ads
    end

    def p_ads(refresh = false)
      ads(refresh).each do |ad|
        puts ad.to_s
      end
      self
    end

    private

    def _ads
      soap_message = service.adgroup_ad.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries/ad")
      @ads = els.map do |el|
        AdgroupAd.from_element( self, el )
      end
    end

    public

    ###########################################################################

    def criterion(&block)
      save
      criterion = Criterion.new(self, &block).save
      @criterions ||= []
      @criterions.push( criterion )
      criterion
    end

    def criterions(refresh = false)
      _criterions unless @criterions and !refresh
      @criterions
    end

    def p_criterions(refresh = false)
      criterions(refresh).each do |criterion|
        puts criterion.to_s
      end
      self
    end

    def find_criterion(criterion_id, refresh = false)
      _criterions unless @criterions and !refresh
      @criterions.find {|c| c.id == criterion_id}
    end

    private

    def _criterions
      soap_message = service.adgroup_criterion.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries/criterion")
      @criterions = els.map do |el|
        Criterion.from_element( self, el )
      end
    end

    public

    ###########################################################################

    def ad_param(criterion, &block)
      save
      ad_param = AdParam.new(self, criterion, &block).save
      @ad_params ||= []
      @ad_params.push( ad_param )
      criterion
    end

    def ad_params(refresh = false)
      _ad_params unless @ad_params and !refresh
      @ad_params
    end

    def p_ad_params(refresh = false)
      ad_params(refresh).each do |ad_param|
        puts ad_param.to_s
      end
      self
    end

    private

    def _ad_params
      soap_message = service.ad_param.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries")
      @ad_params = els.map do |el|
        AdParam.from_element( self, el )
      end
    end

  end
end
