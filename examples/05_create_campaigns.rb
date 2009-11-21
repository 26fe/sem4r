# -------------------------------------------------------------------
# Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
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
puts "---------------------------------------------------------------------"
puts "Running #{File.basename(__FILE__)}"
puts "---------------------------------------------------------------------"

begin

  #
  # config stuff
  #

  #  config = {
  #    :email           => "",
  #    :password        => "",
  #    :developer_token => ""
  #  }
  # adwords = Adwords.sandbox(config)

  adwords = Adwords.sandbox             # search credentials into ~/.sem4r file

  # adwords.dump_soap_to( example_soap_log(__FILE__) )
  adwords.logger = Logger.new(STDOUT)
  # adwords.logger =  example_logger(__FILE__)

  #
  # example body
  #

  puts "Create example campaigns"
  client_account = adwords.account.client_accounts.first

  campaign = Campaign.create(client_account) do
    name "campaign #{Time.now}"
  end
  puts "created campaign '#{campaign.name}' with id '#{campaign.id}'"
  
  adgroup = Adgroup.create(campaign) do
    name "adgroup #{Time.now}"
  end
  puts "created adgroup '#{adgroup.name}' with id '#{adgroup.id}'"

  adgroup_ad = AdgroupAd.create(adgroup) do
    url           "http://www.pluto.com"
    display_url   "www.Pluto.com"
    headline      "Vieni da noi"
    description1  "vieni da noi"
    description2  "arivieni da noi"
  end
  puts "created ad with id '#{adgroup_ad.id}'"

  Criterion.create(adgroup) do
    type       Criterion::KEYWORD
    text       "pippo"
    match_type Criterion::BROAD
  end

  Criterion.create(adgroup) do
    type       Criterion::KEYWORD
    text       "pluto"
    match_type Criterion::BROAD
  end

  Criterion.create(adgroup) do
    type       KEYWORD
    text       "paperino"
    match_type BROAD
  end

  Criterion.create(adgroup) do
    type       PLACEMENT
    url       "http://github.com"
  end


  #
  # dsl
  #

  adgroup_dsl = campaign.adgroup do
    name "adgroup dsl #{Time.now}"

    criterion do
      type       KEYWORD
      text       "dsl paperino"
      match_type BROAD
    end
  end


  campaign.p_adgroups(true)
  adgroup.p_criterions(true)
  adgroup_dsl.p_criterions(true)
  
  adwords.p_counters

rescue Sem4Error
  puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
end

puts "---------------------------------------------------------------------"
