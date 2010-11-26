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

require File.expand_path(File.dirname(__FILE__) + '/../../rspec_helper')


describe ReportDefinition do

  include Sem4rSpecHelper

  before do
    services = double("services")
    stub_service_report_definition(services)
    @account = stub_account(services)
  end

#  it "create should accept a block (instance_eval)" do
#    rd = ReportDefinition.create(@account) do
#      name "report"
#    end
#    rd.name.should  == "report"
#    rd.id.should    == 10
#  end


  #  it "create should accept a block (call)" do
#    adgroup = AdGroup.create(@campaign) do |g|
#      g.name "adgroup"
#    end
#    adgroup.name.should  == "adgroup"
#    adgroup.id.should    == 10
#  end
#
#  it "create should accept a manual cpc bids" do
#    adgroup = AdGroup.create(@campaign) do
#      name "sem4r library"
#      manual_cpc_bids do
#        keyword_max_cpc 10000
#      end
#    end
#    adgroup.bids.should be_instance_of(ManualCPCAdGroupBids)
#  end
#
#  it "create should accept a manual cpm bids" do
#    adgroup = AdGroup.create(@campaign) do
#      name "sem4r library"
#      manual_cpm_bids do
#        max_cpm 10000
#      end
#    end
#    adgroup.bids.should be_instance_of(ManualCPMAdGroupBids)
#  end
#

  it "should build xml (input for google)" do
    pending "test"
    report_definition = ReportDefinition.new(@account) do
      name "report"
#      manual_cpc_bids do
#        keyword_max_cpc 20000000
#        site_max_cpc 30000000
#      end
    end
    exepected_xml = read_model("//operand", "services", "report_definition", "mutate_add-req.xml")
    report_definition.to_xml("operand").should xml_equivalent(exepected_xml)
  end

  #
#  it "should parse xml (produced by google)" do
#    el = read_model("//entries", "services", "ad_group", "get-first-res.xml")
#    adgroup = AdGroup.from_element(@campaign, el)
#    adgroup.id.should == 3060217923
#    adgroup.name.should == "test adgroup"
#    adgroup.status.should == "ENABLED"
#  end
#
#  it "should parse xml (produced by google) with manual cpm bids" do
#    el = read_model("//entries", "services", "ad_group", "get-manual-cpm-bids-res.xml")
#    adgroup = AdGroup.from_element(@campaign, el)
#    adgroup.bids.should be_instance_of(ManualCPMAdGroupBids)
#  end
    


end
