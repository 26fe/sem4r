require 'rubygems'
require 'sem4r'
include Sem4r

adwords = Adwords.sandbox

#adwords = Adwords.sandbox(
#  :email => "<myaccount>@gmail.com",
#  :password => "secret",
#  :developer_token => "<myaccount>@gmail.com++EUR")

account = adwords.account.client_accounts[1]

campaign = account.create_campaign do
  name "new campaign #{Time.now}"

  adgroup do
    name "new adgroup #{Time.now}"
    keyword do
      text       "keyword"
      match      BROAD
    end
    placement do
      url "www.example.com"
    end
  end
end

campaign.p_adgroups(true)
