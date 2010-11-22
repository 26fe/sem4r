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

  module AccountInfoAccountExtension
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

    ###########################################################################

  end

  class Account
    include AccountInfoAccountExtension
  end
  
end
