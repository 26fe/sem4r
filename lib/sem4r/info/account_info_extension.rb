# -------------------------------------------------------------------------
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
# 
# -------------------------------------------------------------------------

module Sem4r

  module AccountInfoExtension
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


    def year_unit_cost(usage_type)
      selector = InfoSelector.new(usage_type)  # (&block)
      soap_message = service.info.get(@credentials, selector.to_xml)

      # raise "usage type '#{usage_type}' not permitted" unless UsageTypes.include?(usage_type)
      # soap_message = service.info.unit_cost(@credentials, usage_type)

      add_counters( soap_message.counters )
      cost = REXML::XPath.first( soap_message.response, "//getResponse/rval/cost")
      cost.text.to_i
    end
  end

  class Account
    enum :UsageTypes, [
      :FREE_USAGE_API_UNITS_PER_MONTH,
      :UNIT_COUNT,
      :TOTAL_USAGE_API_UNITS_PER_MONTH,
      :OPERATION_COUNT,
      :UNIT_COUNT_FOR_CLIENTS,
      :METHOD_COST]
    include AccountInfoExtension
  end

end

