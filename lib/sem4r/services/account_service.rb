module Sem4r
  class AccountService
    include DefineCall

    def initialize(connector)
      @connector = connector
      @service_url = "https://sandbox.google.com/api/adwords/v13/AccountService"
    end

    define_call_v13 :account_info
    define_call_v13 :client_accounts

    private

    def _account_info
      <<-EOFS
      <getAccountInfo xmlns="https://adwords.google.com/api/adwords/v13">
      </getAccountInfo>
      EOFS
    end

    def _client_accounts
      <<-EOFS
      <getClientAccounts xmlns="https://adwords.google.com/api/adwords/v13">
      </getClientAccounts>
      EOFS
    end

  end
end
