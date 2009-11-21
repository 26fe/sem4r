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
    end

    public

    ############################################################################

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

    def year_unit_count
      soap_message = service.info.unit_count(@credentials)
      add_counters( soap_message.counters )
      cost = REXML::XPath.first( soap_message.response, "//getResponse/rval/cost")
      cost.text.to_i
    end

    ############################################################################

    def report(&block)
      Report.new(self, &block)
    end

    ############################################################################

    def reports(refresh = false)
      _reports unless @reports and !refresh
      @reports
    end

    def p_reports(refresh = false)
      reports(refresh).each do |report|
        puts report.to_s
      end
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
    def client_accounts(refresh = false)
      _client_accounts unless @accounts and !refresh
      @accounts
    end

    def p_client_accounts(refresh = false)
      client_accounts(refresh).each do |account|
        puts account.to_s
      end
      self
    end

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

    def campaign(&block)
      Campaign.new(self, &block)
    end

    def campaigns(refresh = false) # conditions = nil
      _campaigns unless @campaigns and !refresh
      @campaigns
      # return @campaigns unless conditions
      # @campaigns.find_all {|c| c.name =~ conditions}
    end

    def p_campaigns(refresh = false) # conditions = nil
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
