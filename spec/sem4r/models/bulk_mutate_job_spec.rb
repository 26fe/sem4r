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

describe BulkMutateJob do
  include Sem4rSpecHelper

  before do
    @adgroup = mock("adgroup").as_null_object
  end

  it "should accept type accessor" do
    # @adgroup.should_receive(:id).and_return(10)

    text_ad = AdGroupTextAd.new(@adgroup)
    text_ad.headline     = "headline"
    text_ad.description1 = "description1"
    text_ad.description2 = "description2"

    ad_operation = AdGroupAdOperation.new
    ad_operation.add text_ad

    job = BulkMutateJob.new
    job.campaign_id = 100
    job.add_operation ad_operation

    job.should have(1).operations
  end

  it "should parse xml" do
    el = read_model("//rval", "services", "bulk_mutate_job_service", "get-res.xml")
    job = BulkMutateJob.from_element(el)
    job.id.should == 56889
    job.status.should == "PENDING"
  end


  it "should have a representation in xml" do
    pending "test"
    @adgroup.should_receive(:id).and_return(10)

    text_ad = AdGroupTextAd.new(@adgroup)
    text_ad.headline     = "headline"
    text_ad.description1 = "description1"
    text_ad.description2 = "description2"

    ad_operation = AdGroupAdOperation.new
    ad_operation.add text_ad

    job = BulkMutateJob.new
    job.campaign_id = 100
    job.add_operation ad_operation

    xml = job.to_xml

    expected = read_model("//operand", "services", "bulk_mutate_job_service", "mutate-req.xml")
    xml_wns = xml.gsub(/ns\d:/, "").gsub(/xsi:/,'')
    diff = xml_cmp expected, xml_wns
    diff.should == true
  end
end

