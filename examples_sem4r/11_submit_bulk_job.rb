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

require File.expand_path( File.join( File.dirname(__FILE__), "example_helper") )


def create_bulk_mutate_job(campaign, adgroup)
  text_ad1 = AdGroupTextAd.new(adgroup)
  text_ad1.headline     = "Cruise to Mars Sector 1"
  text_ad1.description1 = "Visit the Red Planet in style."
  text_ad1.description2 = "Low-gravity fun for everyone!"
  text_ad1.url          = "http://www.example.com"
  text_ad1.display_url  = "www.example.com"

  text_ad2 = AdGroupTextAd.new(adgroup)
  text_ad2.headline     = "Cruise to Mars Sector 2"
  text_ad2.description1 = "Visit the Red Planet in style."
  text_ad2.description2 = "Low-gravity fun for everyone!"
  text_ad2.url          = "http://www.example.com"
  text_ad2.display_url  = "www.example.com"

  bulk_mutate_job = BulkMutateJob.new
  bulk_mutate_job.campaign_id = campaign.id

  ad_operation1 = AdGroupAdOperation.new
  ad_operation1.add text_ad1

  ad_operation2 = AdGroupAdOperation.new
  ad_operation2.add text_ad2

  job = BulkMutateJob.new
  job.campaign_id = 100
  job.add_operation ad_operation1
  job.add_operation ad_operation2
  job
end

run_example(__FILE__) do |adwords|

  account = adwords.account
  client_account = adwords.account.client_accounts.first

  campaign = Campaign.create(client_account) do
    name "campaign #{Time.now.strftime('%m%d-%H%M%S')}"
  end

  ad_group = campaign.ad_group do
    name "adgroup #{Time.now.strftime('%m%d-%H%M%S')}"
  end

  puts "created campaign '#{campaign.name}' with id '#{campaign.id}'"
  puts "created adgroup '#{ad_group.name}' with id '#{ad_group.id}'"

  job = create_bulk_mutate_job(campaign, ad_group)

  job_operation = JobOperation.new
  job_operation.add(job)

  result_job = account.job_mutate(job_operation)

  puts result_job.to_s
end
