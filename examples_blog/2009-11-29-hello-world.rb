require 'rubygems'
require 'sem4r'
include Sem4r

adwords = Adwords.sandbox

#adwords = Adwords.sandbox(
#  :email => "<myaccount>@gmail.com",
#  :password => "secret",
#  :developer_token => "<myaccount>@gmail.com++EUR")
adwords.account.p_client_accounts
