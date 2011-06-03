# -*- coding: utf-8 -*-
# -------------------------------------------------------------------
# Copyright (c) 2009-2011 Sem4r sem4ruby@gmail.com
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

module FixtureCampaign

  def fixtures_campaign
    @dump_interceptor.reset_and_stop

    client_account = @adwords.account.client_accounts[1]

    puts "inspect account '#{client_account.credentials.client_email}'"
    client_account.campaigns.each do |campaign|
      puts "delete campaign '#{campaign.name}'"
      campaign.delete
    end

    campaign = nil
    intercept("mutate_add") {
      campaign = client_account.campaign "sem4r campaign #{Time.now.strftime('%m%d-%H%M%S')}" do
      end
    }

    adgroup = nil
    intercept("mutate_add") {
      adgroup = campaign.ad_group "sem4r adgroup #{Time.now.strftime('%m%d-%H%M%S')}" do
#        manual_cpm_bids do
#          max_cpm 20000000
#        end
        manual_cpc_bids do
          site_max_cpc 30000000
          keyword_max_cpc 20000000
        end
      end
    }

    intercept("mutate_add_text_ad_1") {
      adgroup.text_ad do
        url "http://www.sem4r.com"
        display_url "www.Sem4R.com"
        headline "adwords api library"
        description1 "adwords made simple"
        description2 "set up you campaigns in a snap!"
      end
      adgroup.save
    }

    @dump_interceptor.reset_and_stop
    intercept("mutate_add_criterion_keyword") {
      keyword = adgroup.keyword do
        text       "sem4r adwords api"
        match      "BROAD"
      end
#      bids = ManualCPCAdGroupCriterionBids.new
#      bids.max_cpc 10000000
#
#      biddable_criterion = BiddableAdGroupCriterion.new(ad_group)
#      biddable_criterion.criterion keyword
#      biddable_criterion.bids bids
      adgroup.save
    }


    @dump_interceptor.reset_and_stop
    intercept("get") {
      client_account.campaigns(true)
    }
  end

end
