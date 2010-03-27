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

  CliListAds = CliCommand.define_command("ads", "list ads") do |account|
    puts "List AdGroup Advertising"

    account.client_accounts.each do |client_account|
      puts "examinate account '#{client_account.credentials.client_email}'"
      client_account.campaigns.each do |campaign|
        puts "examinate campaign '#{campaign}'"
        campaign.ad_groups.each do |ad_group|
          puts "examinate adgroup '#{ad_group}'"
          ad_group.ads.each do |ad|
            row = []
            row << client_account.credentials.client_email
            row << campaign.name
            row << ad_group.name
            row << ad.url
            row << ad.display_url
            puts row.join(",")
          end
        end
      end
    end
    account.adwords.p_counters

  end
end
