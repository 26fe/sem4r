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

  CliListClient = CliCommand.define_command("clients", "list clients account") do |account|
    puts account.adwords.to_s
    puts account.to_s    
    account.p_client_accounts
    account.adwords.p_counters
  end
  
  CliListReport = CliCommand.define_command("reports", "list reports") do |account|
    report(account.reports, :id, :name, :status)
    account.adwords.p_counters
  end

  CliInfo = CliCommand.define_command("info", "account info") do |account|
    account.p_info    
    items = (Account::UsageTypes - [Account::METHOD_COST]).map do |usage_type|
      n = account.year_unit_cost(usage_type)
      # puts "#{usage_type} -> #{n}"
      OpenStruct.new(:usage_type => usage_type, :n => n)
    end
    report(items, :usage_type, :n)
    account.adwords.p_counters
  end

  CliCampaign = CliCommand.define_command("campaigns", "list campaigns") do |account|
    puts "listing campaings in #{account}"
    report( account.campaigns, :id, :name, :status )
    account.adwords.p_counters
  end

end
