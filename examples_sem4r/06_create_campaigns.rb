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

  campaign = Campaign.create(client_account) do
    name "campaign #{Time.now}"
  end
  puts "created campaign '#{campaign.name}' with id '#{campaign.id}'"

  adgroup = AdGroup.create(campaign) do
    name "adgroup #{Time.now}"
  end
  puts "created adgroup '#{adgroup.name}' with id '#{adgroup.id}'"

  adgroup_ad = AdGroupTextAd.new(adgroup) do
    url           "http://www.sem4r.com"
    display_url   "www.Sem4R.com"
    headline      "adwords api library"
    description1  "adwords made simple"
    description2  "set up you campaings in a snap"
  end
  puts "created ad with id '#{adgroup_ad.id}'"

  CriterionKeyword.new(adgroup) do
    text       "pippo"
    match      "BROAD"
  end

  CriterionKeyword.new(adgroup) do
    text       "pluto"
    match      "BROAD"
  end

  CriterionKeyword.new(adgroup) do
    text       "paperino"
    match      "BROAD"
  end

  CriterionPlacement.new(adgroup) do
    url       "http://github.com"
  end

  #
  # dsl
  #

  adgroup_dsl = campaign.ad_group do
    name "adgroup dsl #{Time.now}"

    keyword do
      text  "dsl paperino"
      match "BROAD"
    end
  end

  campaign.p_ad_groups(true)
  adgroup.p_criterions(true)
  adgroup_dsl.p_criterions(true)

end
