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
  puts "Create an adgroup with adparam"

  client_account = adwords.account.client_accounts[1]

  if client_account.campaigns.length != 0
    campaign = client_account.campaigns[0]
  else
    campaign = client_account.campaign do
      name "campaign #{Time.now}"
    end
  end

  campaign.ad_group do
    name "ad_group #{Time.now}"

    text_ad do
      url           "http://www.pluto.com"
      display_url   "www.Pluto.com"
      headline      "Vieni da noi"
      description1  "vieni da noi"
      description2  "arivieni da noi"
    end

    keyword do
      text       "pippo"
      match      "BROAD"

      ad_param do
        index 1
        text  "$99.99"
      end

      ad_param do
        index 2
        text  "10"
      end
    end
  end

  campaign.ad_groups(true).each do |ad_group|
    ad_group.p_ad_params
  end

end
