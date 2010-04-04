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
  name "new campaign #{Time.now.strftime('%m%d-%H%M%S')}"

  adgroup do
    name "new adgroup #{Time.now.strftime('%m%d-%H%M%S')}"
    keyword do
      text       "keyword"
      match      "BROAD"
    end
    placement do
      url "www.example.com"
    end
  end
end

campaign.p_adgroups(true)
