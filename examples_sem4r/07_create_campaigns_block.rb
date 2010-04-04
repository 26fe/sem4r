# -------------------------------------------------------------------
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
# -------------------------------------------------------------------

require File.dirname(__FILE__) + "/example_helper"

run_example(__FILE__) do |adwords|

  puts "Create example campaigns"
  client_account = adwords.account.client_accounts.first

  #
  # 1. campaign
  #
  campaign = client_account.campaign "sem4r web campaign #{Time.now}" do
  
    bidding_strategy "ManualCPM"
  
    ad_group "sem4r search page #{Time.now}" do
  
      manual_cpm_bids do
        max_cpm 20000000
      end
  
      text_ad do
        url           "http://www.sem4r.com"
        display_url   "www.Sem4R.com"
        headline      "adwords api library"
        description1  "adwords made simple"
        description2  "set up you campaings in a snap!"
      end
  
      keyword   "adwords api",  "BROAD"
      # keyword   "ruby adwords", "BROAD"
      # placement "http://github.com"
  
      negative_keyword "java api library"
    end
  end
  campaign.p_ad_groups(true)

  #
  # 2 campaign
  #

  campaign = client_account.campaign "sem4r mobile campaign #{Time.now}" do

    bidding_strategy "ManualCPC"

    ad_group "sem4r on mobile #{Time.now}" do
      manual_cpc_bids do
        keyword_max_cpc 21000000
        site_max_cpc    22000000
      end

      mobile_ad do
        headline      "sem4r"
        description   "simply adwords"
        # markup        "XHTML"
        # carrier       "Vodafone@IT"
        carrier  'ALLCARRIERS'
        business_name "sem4r"
        country_code  "IT"
        phone_number  "0612345"
      end

      keyword "adwords api", "BROAD" do
        # status "PAUSED"
        # url  "pippo"
        #        max_cpc 32423423
        #        max_cpm 232321
      end

      keyword "ruby adwords", "BROAD"
    end
  end

  campaign.p_ad_groups(true)

end
