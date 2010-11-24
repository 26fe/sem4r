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

    enum :ServingStatues, [
      :SERVING,
      :NONE,
      :ENDED,
      :PENDING,
      :SUSPENDED
    ]
    
    attr_reader :id
    attr_reader :account

    g_accessor :name
    g_accessor :status, {:default => "PAUSED"}
    g_accessor :serving_status
    g_accessor :start_date
    g_accessor :end_date

    def initialize(account, name = nil, &block)
      super( account.adwords, account.credentials )
      @account = account
      @ad_groups = nil
      self.name = name
      if block_given?
        @inside_initialize = true
        block.arity < 1 ? instance_eval(&block) : block.call(self)
        save
      end
      @inside_initialize = false
    end

    def inside_initialize?
      @inside_initialize
    end

    def to_s
      "#{@id} '#{@name}' (#{@status})"
    end

    def to_xml
      <<-EOS
        <name>#{name}</name>
        <status>#{status}</status>

        <budget>
          <period>DAILY</period>
          <amount xsi:type="Money">
            <microAmount>50000000</microAmount>
          </amount>
          <deliveryMethod>STANDARD</deliveryMethod>
        </budget>

        <biddingStrategy xsi:type="#{bidding_strategy}"></biddingStrategy>

      EOS
    end

    ###########################################################################

    def self.from_element(account, el)
      new(account) do
        @id          = el.elements["id"].text.strip.to_i
        name           el.elements["name"].text.strip
        status         el.elements['status'].text.strip # ACTIVE, PAUSED, DELETED
        serving_status el.elements['servingStatus']
        start_date     el.elements['startDate']
        end_date       el.elements['endDate']
        #=======
        #        @id          = el.at_xpath("id").text.strip.to_i
        #        name           el.at_xpath("name").text.strip
        #        status         el.at_xpath('status').text.strip # ACTIVE, PAUSED, DELETED
        #        serving_status el.at_xpath('servingStatus')
        #        start_date     el.at_xpath('startDate')
        #        end_date       el.at_xpath('endDate')
        #>>>>>>> wordtracker/master
      end
    end

    def self.create(account, &block)
      new(account, &block).save
    end

    def save
      unless @id
        soap_message = service.campaign.create(credentials, to_xml)
        add_counters( soap_message.counters )
        rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
        id = REXML::XPath.match( rval, "value/id" ).first
        #=======
        #        rval = soap_message.response.xpath("//mutateResponse/rval").first
        #        id = rval.xpath("value/id").first
        #>>>>>>> wordtracker/master
        @id = id.text.strip.to_i
      end
      self
    end

    def delete
      soap_message = service.campaign.delete(credentials, @id)
      add_counters( soap_message.counters )
      @id = -1 # logical delete
    end

    ###########################################################################

    def empty?
      _ad_groups.empty?
    end

    ###########################################################################
    # bidding_strategy

    # ManualCPC, ManualCPM
    def bidding_strategy(strategy = nil)
      @bidding_strategy = strategy if strategy
      @bidding_strategy ||= "ManualCPC"
      @bidding_strategy
    end

    ###########################################################################
    # ad_group management

    def ad_group(name = nil, &block)
      save
      ad_group = AdGroup.new(self, name, &block)
      ad_group.save
      @ad_groups ||= []
      @ad_groups.push(ad_group)
      ad_group
    end

    def ad_groups(refresh = false, opts = {})
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end
      _ad_groups unless @ad_groups and !refresh
      # statuses = [:ACTIVE, :PAUSED]
      # @ad_groups.select do |ad_group|
      #   statuses.include?(ad_group.status)
      # end
      @ad_groups
    end

    def p_ad_groups(refresh = false, opts = {})
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end
      cs = ad_groups(refresh, opts)
      puts "#{cs.length} ad_groups"
      cs.each do |ad_group|
        puts ad_group.to_s
      end
      self
    end

    private

    def _ad_groups
      soap_message = service.ad_group.all(credentials, @id)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries")
      #      =======
      #        rval = soap_message.response.xpath("//getResponse/rval").first
      #      els = rval.xpath( "entries")
      #      >>>>>>> wordtracker/master
      @ad_groups = els.map do |el|
        AdGroup.from_element(self, el)
      end
    end

    ###########################################################################

  end
end
