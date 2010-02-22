require 'rubygems'
require 'sem4r'
include Sem4r

adwords = Adwords.sandbox

#adwords = Adwords.sandbox(
#  :email => "<myaccount>@gmail.com",
#  :password => "secret",
#  :developer_token => "<myaccount>@gmail.com++EUR")

client_account = adwords.account.client_accounts.first

campaign = client_account.campaign do
  name "Skis"

  adgroup do
    name "Skis for sales"

    text_ad do
      headline      "Save on Rossignol skis"
      description1  "Great deal on Rissignol starting at"
      description2  "{param1:lowprices}! Save {param2: big time}!"
      url           "http://skideals.com"
      display_url   "www.SkiDeals.com"
    end

    keyword do
      text       "ski deal rossignol"
      match      "BROAD"

      ad_param do
        index 1
        text  "$279"
      end

      ad_param do
        index 2
        text  "20%"
      end
    end
  end
end

campaign.adgroups(true).each do |adgroup|
  adgroup.p_ad_params
end
