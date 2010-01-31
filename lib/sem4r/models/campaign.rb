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

  class Campaign < Base

    enum :Statuses, [
      :ACTIVE,
      :PAUSED,
      :DELETED
    ]

    #
    # enum ServingStatus
    #
    enum :ServingStatues, [
      :SERVING,
      :NONE,
      :ENDED,
      :PENDING,
      :SUSPENDED
    ]
    
    attr_reader :id
    attr_reader :account

    def initialize(account, &block)
      super( account.adwords, account.credentials )
      @account = account
      @adgroups = nil
      if block_given?
        instance_eval(&block)
        save
      end
    end

    def to_s
      "#{@id} '#{@name}' (#{@status})"
    end

    def to_xml
      <<-EOS
        <name>#{name}</name>
        <status>PAUSED</status>
        <budget>
          <period>DAILY</period>
          <amount xsi:type="Money">
            <microAmount>50000000</microAmount>
          </amount>
          <deliveryMethod>STANDARD</deliveryMethod>
        </budget>
        <biddingStrategy xsi:type="ManualCPC"></biddingStrategy>
      EOS
    end

    ###########################################################################

    g_accessor :name
    g_accessor :status
    g_accessor :serving_status
    g_accessor :start_date
    g_accessor :end_date

    ###########################################################################

    #  <entries>
    #      <id>5557</id>
    #      <name>campaign 2009-11-14 17:09:45 +0100</name>
    #      <status>PAUSED</status>
    #      <servingStatus>SERVING</servingStatus>
    #      <startDate>20091114</startDate>
    #      <endDate>20371231</endDate>
    #      <budget>
    #          <period>DAILY</period>
    #          <amount>
    #              <ComparableValue.Type>Money</ComparableValue.Type>
    #              <microAmount>50000000</microAmount>
    #          </amount>
    #          <deliveryMethod>STANDARD</deliveryMethod>
    #      </budget>
    #      <biddingStrategy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ManualCPC">
    #          <BiddingStrategy.Type>ManualCPC</BiddingStrategy.Type>
    #      </biddingStrategy>
    #      <autoKeywordMatchingStatus>OPT_OUT</autoKeywordMatchingStatus>
    #      <stats>
    #          <network>ALL</network>
    #          <clicks>0</clicks>
    #          <impressions>0</impressions>
    #          <cost>
    #              <ComparableValue.Type>Money</ComparableValue.Type>
    #              <microAmount>0</microAmount>
    #          </cost>
    #          <averagePosition>0.0</averagePosition>
    #          <averageCpc>
    #              <ComparableValue.Type>Money</ComparableValue.Type>
    #              <microAmount>0</microAmount>
    #          </averageCpc>
    #          <averageCpm>
    #              <ComparableValue.Type>Money</ComparableValue.Type>
    #              <microAmount>0</microAmount>
    #          </averageCpm>
    #          <ctr>0.0</ctr>
    #          <conversions>0</conversions>
    #          <conversionRate>0.0</conversionRate>
    #          <costPerConversion>
    #              <ComparableValue.Type>Money</ComparableValue.Type>
    #              <microAmount>0</microAmount>
    #          </costPerConversion>
    #          <conversionsManyPerClick>0</conversionsManyPerClick>
    #          <conversionRateManyPerClick>0.0</conversionRateManyPerClick>
    #          <costPerConversionManyPerClick>
    #              <ComparableValue.Type>Money</ComparableValue.Type>
    #              <microAmount>0</microAmount>
    #          </costPerConversionManyPerClick>
    #          <Stats.Type>Stats</Stats.Type>
    #      </stats>
    #      <frequencyCap>
    #          <impressions>0</impressions>
    #      </frequencyCap>
    #  </entries>

    def self.from_element(account, el)
      new(account) do
        @id          = el.elements["id"].text
        name           el.elements["name"].text
        status         el.elements['status'].text # ACTIVE, PAUSED, DELETED
        serving_status el.elements['servingStatus']
        start_date     el.elements['startDate']
        end_date       el.elements['endDate']
      end
    end

    def self.create(account, &block)
      new(account, &block).save
    end

    ###########################################################################

    def empty?
      _adgroups.empty?
    end

    ###########################################################################
    def save
      unless @id
        soap_message = service.campaign.create(credentials, to_xml)
        add_counters( soap_message.counters )
        rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
        id = REXML::XPath.match( rval, "value/id" ).first
        @id = id.text
      end
      self
    end

    def delete
      soap_message = service.campaign.delete(credentials, @id)
      add_counters( soap_message.counters )
      @id = -1 # logical delete
    end

    ###########################################################################

    def adgroup(&block)
      save
      adgroup = Adgroup.new(self, &block)
      adgroup.save
      @adgroups ||= []
      @adgroups.push(adgroup)
      adgroup
    end

    def adgroups(refresh = false, opts = {})
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end
      _adgroups unless @adgroups and !refresh
      statuses = [:ACTIVE, :PAUSED]
      @adgroups.select do |adgroup|
        statuses.include?(adgroup.status)
      end
    end

    def p_adgroups(refresh = false, opts = {})
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end
      cs = adgroups(refresh, opts)
      puts "#{cs.length} adgroups"
      cs.each do |adgroup|
        puts adgroup.to_s
      end
      self
    end

    private

    def _adgroups
      soap_message = service.adgroup.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries")
      @adgroups = els.map do |el|
        Adgroup.from_element(self, el)
      end
    end

  end
end
