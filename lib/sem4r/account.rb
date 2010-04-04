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

  class Account < Base
    
    def initialize( adwords, credentials )
      super( adwords, credentials )
      @campaigns = nil
      @reports = nil
    end

    def to_s
      credentials.to_s
    end

    def client_email
      credentials.client_email
    end

    ############################################################################
    # Info Service

    # FREE_USAGE_API_UNITS_PER_MONTH
    #   Retrieves the number of  free API units that can be used by the developer
    #   token being used to make the call for this month.
    #   Specify only the apiUsageType parameter.
    #
    # TOTAL_USAGE_API_UNITS_PER_MONTH
    #   Retrieves the total number of API units for this entire month that can
    #   be used by the developer token being used to make this call. Includes
    #   both free and paid API units.
    #   Specify only the apiUsageType parameter.
    #
    # OPERATION_COUNT
    #   Retrieves the number of operations recorded for the developer token
    #   being used to make this call over the given date range.
    #   The given dates
    #   are inclusive; to get the operation count for a single day, supply it as
    #   both the start and end date.
    #   Specify the apiUsageType and dateRange parameters.
    #
    # UNIT_COUNT
    #   Retrieves the number of API units recorded for the developer token being
    #   used to make this call.
    #     o Specify the apiUsageType and dateRange parameters to retrieve
    #       the units recorded over the given date range.
    #     o Specify the apiUsageType, serviceName, methodName, operator,
    #       dateRange to retrieve the units recorded over the given date
    #       range for a specified method.
    #
    # UNIT_COUNT_FOR_CLIENTS
    #   Retrieves the number of API units recorded for a subset of clients over
    #   the given date range for the developer token being used to make this
    #   call.
    #   The given dates are inclusive; to get the unit count for a single
    #   day, supply it as both the start and end date.
    #   Specify the apiUsageType, dateRange and clientEmails parameters.
    #
    # METHOD_COST
    #   Retrieves the cost, in API units per operation, of the given method on
    #   a specific date for the developer token being used to make this call.
    #
    #   Methods default to a cost of 1. Specify the apiUsageType, dateRange
    #   (start date and end date should be the same), serviceName, methodName,
    #   operator parameters.

    enum :UsageTypes, [
      :FREE_USAGE_API_UNITS_PER_MONTH,
      :UNIT_COUNT,
      :TOTAL_USAGE_API_UNITS_PER_MONTH,
      :OPERATION_COUNT,
      :UNIT_COUNT_FOR_CLIENTS,
      :METHOD_COST]

    def year_unit_cost(usage_type)
      raise "usage type '#{usage_type}' not permitted" unless UsageTypes.include?(usage_type)
      soap_message = service.info.unit_cost(@credentials, usage_type)
      add_counters( soap_message.counters )
      cost = REXML::XPath.first( soap_message.response, "//getResponse/rval/cost")
      cost.text.to_i
    end

    ############################################################################
    # Targeting Idea

    def targeting_idea(&block)
      selector = TargetingIdeaSelector.new(&block)
      soap_message = service.targeting_idea.get(@credentials, selector.to_xml)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries")
      els.map do |el|
        TargetingIdea.from_element( el )
      end
    end

    def p_targeting_idea(&block)
      targeting_ideas = targeting_idea(&block)
      targeting_ideas.each{ |idea| puts idea }
    end

    ############################################################################
    # Bulk Jobs

    def p_jobs
      selector = BulkMutateJobSelector.new
      soap_message = service.bulk_mutate_job.all(credentials, selector)
      add_counters( soap_message.counters )
      els = REXML::XPath.match( soap_message.response, "//getResponse/rval")
      jobs = els.map do |el|
        BulkMutateJob.from_element(el)
      end

      puts "#{jobs.length} bulk mutate jobs"
      jobs.each do |job|
        puts job.to_s
      end
      self
    end

    def job_mutate(bulk_mutate_job)
      soap_message = service.bulk_mutate_job.mutate(credentials, bulk_mutate_job)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//rval")
      BulkMutateJob.from_element(el)
    end

    ############################################################################
    # Geo Location

    def geo_location
      soap_message = service.geo_location.get(@credentials, "")
      add_counters( soap_message.counters )
      # cost = REXML::XPath.first( soap_message.response, "//getResponse/rval/cost")
      # cost.text.to_i
    end

    ############################################################################
    # Reports - Service Report

    def report(&block)
      Report.new(self, &block)
    end

    def p_reports(refresh = false)
      reports(refresh).each do |report|
        puts report.to_s
      end
    end

    def reports(refresh = false)
      _reports unless @reports and !refresh
      @reports
    end

    private

    def _reports
      soap_message = service.report.all(credentials)
      add_counters( soap_message.counters )
      els = REXML::XPath.match( soap_message.response, "//getAllJobsResponse/getAllJobsReturn")
      @reports = els.map do |el|
        Report.from_element(self, el)
      end
    end

    public

    ############################################################################
    # Info Account - Service Account

    def p_info
      _info unless @currency_code
      puts "currency_code: #{@currency_code}"
      puts "customer_id: #{@customer_id}"
      puts @billing_address
    end

    def currency_code
      _info unless @currency_code
      @currency_code
    end

    def customer_id
      _info unless @customer_id
      @customer_id
    end

    private

    def _info
      soap_message = service.account.account_info(credentials)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//getAccountInfoResponse/getAccountInfoReturn")
      @currency_code = el.elements['currencyCode'].text.strip
      @customer_id   = el.elements['customerId'].text.strip
      @billing_address = BillingAddress.from_element( el.elements['billingAddress'] )
    end

    public

    ############################################################################
    # Account - Service Account

    def client_accounts(refresh = false)
      _client_accounts unless @accounts and !refresh
      @accounts
    end

    def p_client_accounts(refresh = false)
      cs = client_accounts(refresh)
      # puts "#{cs.length} client accounts"
      cs.each do |account|
        puts account.to_s
      end
      self
    end

    alias clients client_accounts
    alias p_clients p_client_accounts

    private

    def _client_accounts
      soap_message = service.account.client_accounts(credentials)
      add_counters( soap_message.counters )
      els = REXML::XPath.match( soap_message.response, "//getClientAccountsReturn")
      @accounts = els.map do |el|
        client_email = el.text
        Account.new( adwords, Credentials.new(@credentials, client_email) )
      end
    end

    public

    ############################################################################
    # Campaign - Service Campaign

    # TODO: accettare un parametro opzionale campaign(name=nil,&block)
    #       la campagna che verra' creata ha il nome gia' settato
    #       se esiste gia' una campagna con quel nome allora fara' da contesto
    #       e non verra' creata
    def campaign(name = nil, &block)
      campaign = Campaign.new(self, name, &block)
      campaign.save
      @campaigns ||= []
      @campaigns.push(campaign)
      campaign
    end

    alias create_campaign campaign

    def campaigns(refresh = false, opts = {}) # conditions = nil
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end
      _campaigns unless @campaigns and !refresh
      @campaigns
      # return @campaigns unless conditions
      # @campaigns.find_all {|c| c.name =~ conditions}
    end

    def p_campaigns(refresh = false, opts = {}) # conditions = nil
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end

      cs = campaigns(refresh, opts)
      puts "#{cs.length} campaigns"
      campaigns(refresh).each do |campaign|
        puts campaign.to_s
      end
      self
    end

    private

    def _campaigns
      soap_message = service.campaign.all(credentials)
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//getResponse/rval")
      els = REXML::XPath.match( rval, "entries")
      @campaigns = els.map do |el|
        Campaign.from_element(self, el)
      end
    end

    public

    ###########################################################################

  end
end
