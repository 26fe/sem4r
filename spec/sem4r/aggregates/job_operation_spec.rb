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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe JobOperation do

  def create_bulk_mutate_job(campaign, adgroup)
    text_ad1 = AdGroupTextAd.new(adgroup)
    text_ad1.headline     = "Cruise to Mars Sector 1"
    text_ad1.description1 = "Visit the Red Planet in style."
    text_ad1.description2 = "Low-gravity fun for everyone!"
    text_ad1.url          = "http://www.example.com"
    text_ad1.display_url  = "www.example.com"

    bulk_mutate_job = BulkMutateJob.new
    bulk_mutate_job.campaign_id = campaign.id

    ad_operation1 = AdGroupAdOperation.new
    ad_operation1.add text_ad1

    job = BulkMutateJob.new
    job.campaign_id = 100
    job.add_operation ad_operation1
    job
  end

  it "should produce xml" do

    @campaign = mock("campaign").as_null_object
    @adgroup = mock("adgroup").as_null_object

    bulk_mutate_job = create_bulk_mutate_job(@campaign, @adgroup)
    job_operation = JobOperation.new
    job_operation.add(bulk_mutate_job)
    job_operation.to_xml

    #    @adgroup = mock("adgroup").as_null_object
    #    @ad_operation = AdGroupAdOperation.new
    #    @adgroup.should_receive(:id).and_return(10)
    #    text_ad = AdGroupTextAd.new(@adgroup)
    #    text_ad.headline     = "headline"
    #    text_ad.description1 = "description1"
    #    text_ad.description2 = "description2"
    #    @ad_operation.add text_ad
    #    puts @ad_operation.to_xml
  end

end
