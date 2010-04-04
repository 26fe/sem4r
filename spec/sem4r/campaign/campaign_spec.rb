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


describe Campaign do

  include Sem4rSpecHelper

  before do
    services = double("services")
    stub_service_campaign(services)
    stub_service_ad_group(services)
    @account = stub_account(services)
  end

  describe "campaign management" do

    it "create should accept a block (instance_eval)" do
      campaign = Campaign.create(@account) do
        name "campaign"
      end
      campaign.name.should  == "campaign"
      campaign.id.should    == 10
    end

    it "create should accept a block (call)" do
      campaign = Campaign.create(@account) do |c|
        c.name "campaign"
      end
      campaign.name.should  == "campaign"
      campaign.id.should    == 10
    end

    it "should parse xml (produced by google)" do
      el = read_model("//entries", "services", "campaign", "get-res.xml")
      campaign = Campaign.from_element(@account, el)
      campaign.id.should == 53614
      campaign.name.should == "test campaign"
      campaign.status.should == "PAUSED"
    end

  end

  describe "adgroup management" do

    it "should add an AdGroup with method 'ad_group' + block" do
      campaign = Campaign.new(@account) do
        name "campaign"
        ad_group do
          name "adgroup"
        end
      end
      campaign.ad_groups.length.should   == 1
      ad_group = campaign.ad_groups.first
      ad_group.id.should == 10
      ad_group.name.should == "adgroup"
    end

    it "should add an AdGroup with method 'ad_group' + param" do
      campaign = Campaign.new(@account) do
        name "campaign"
        ad_group "adgroup"
      end
      campaign.ad_groups.length.should   == 1
      ad_group = campaign.ad_groups.first
      ad_group.id.should == 10
      ad_group.name.should == "adgroup"
    end

  end

  describe "bidding and budget" do

    it "should accept a bidding_startegy" do
      campaign = Campaign.create(@account) do
        bidding_strategy "ManualCPM"
      end
      campaign.bidding_strategy.should  == "ManualCPM"
    end

  end
end
