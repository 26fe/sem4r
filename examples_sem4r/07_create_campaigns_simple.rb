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
  campaign = client_account.campaign "sem4r web campaign #{Time.now.strftime('%m%d-%H%M%S')}" do
  
    ad_group "sem4r search page #{Time.now.strftime('%m%d-%H%M%S')}" do

      text_ad do
        url           "http://www.sem4r.com"
        display_url   "www.Sem4R.com"
        headline      "adwords api library"
        description1  "adwords made simple"
        description2  "set up you campaings in a snap!"
      end
  
      text_ad do
        url           "http://www.sem4r.com"
        display_url   "www.Sem4R.com"
        headline      "adwords library"
        description1  "no more headache"
        description2  "set up you campaings in a snap!"
      end

      puts      "first keyword"
      keyword   "adwords api",  "BROAD"
      puts      "second keyword"
      keyword   "ruby adwords", "BROAD"
    end
  end

  puts "created campaign '#{campaign.name}'"
  adgroup = campaign.ad_groups.first
  adgroup.p_ads
  adgroup.p_criterions
end
