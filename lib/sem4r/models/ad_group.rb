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

module Sem4r
  class AdGroup < Base

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
    
    g_accessor :name
    g_accessor :status

    def initialize(campaign, name = nil, &block)
      super( campaign.adwords, campaign.credentials )
      @campaign = campaign
      @id = nil
      @criterions = nil
      self.name = name unless name.nil?
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

    def bid(el)
      @bid = AdGroupBid.from_element(el)
    end

    ###########################################################################
    # campaign management

    def self.from_element(campaign, el)
      new(campaign) do
        @id          = el.elements["id"].text.strip.to_i
        name           el.elements["name"].text
        status         el.elements["status"].text
        bid            el.elements["bids"]
      end
    end

    def self.create(campaign, &block)
      new(campaign, &block).save
    end

    def save
      unless @id
        soap_message = service.ad_group.create(credentials, to_xml)
        add_counters( soap_message.counters )
        rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
        id = REXML::XPath.match( rval, "value/id" ).first
        @id = id.text.strip.to_i
      end
      # save all criterion
      @criterions.each { |criterion| criterion.save } if @criterions
      # save ads
      @ads.each{ |ad| ad.save } if @ads
      self
    end

    def delete
      soap_message = service.ad_group.delete(credentials, @id)
      add_counters( soap_message.counters )
      @id = -1 # logical delete
    end

    ###########################################################################
    # ad management

    def text_ad(&block)
      save
      ad = AdGroupTextAd.new(self, &block)
      @ads ||= []
      @ads.push(ad)
      ad
    end

    def mobile_ad(&block)
      save
      ad = AdGroupMobileAd.new(self, &block)
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
      soap_message = service.ad_group_ad.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries/ad")
      @ads = els.map do |el|
        AdGroupAd.from_element( self, el )
      end
    end

    public

    ###########################################################################
    # criterion management

    def keyword(text = nil, match = nil, &block)
      save
      criterion = CriterionKeyword.new(self, text, match, &block)
      criterion.save
      @criterions ||= []
      @criterions.push( criterion )
      criterion
    end

    def placement(url = nil, &block)
      save
      criterion = CriterionPlacement.new(self, url, &block)
      criterion.save
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
      soap_message = service.ad_group_criterion.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries/criterion")
      @criterions = els.map do |el|
        Criterion.from_element( self, el )
      end
    end

    public

    ###########################################################################
    # ad param management

    def ad_param(criterion, index = nil, text = nil, &block)
      save
      ad_param = AdParam.new(self, criterion, index, text, &block)
      ad_param.save
      @ad_params ||= []
      @ad_params.push( ad_param )
      ad_param
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
