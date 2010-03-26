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

describe AdGroupAd do

  include Sem4rSpecHelper

  before(:each) do
    services = stub("services")
    stub_service_ad_group_criterion(services)
    stub_service_ad_group_ad(services)
    @adgroup = stub_adgroup(services, 3060217927)
  end

  describe AdGroupAd do

    it "should parse xml (output from google)" do
      el = read_model("//ad", "services", "ad_group_ad_service", "get_text_ad-res.xml")
      ad = AdGroupAd.from_element(@adgroup, el)
      # ad.id.should == 218770
      ad.url.should == "http://www.pluto.com"
      ad.headline.should == "Vieni da noi"
    end

  end

  describe AdGroupTextAd do

    it "should accepts accessor" do
      text_ad = AdGroupTextAd.new(@adgroup)
      text_ad.headline     = "headline"
      text_ad.description1 = "description1"
      text_ad.description2 = "description2"

      text_ad.headline.should     == "headline"
      text_ad.description1.should == "description1"
      text_ad.description2.should == "description2"
      text_ad.status.should == "ENABLED"
    end
  
    it "should accepts a block (instance_eval)" do
      text_ad = AdGroupTextAd.new(@adgroup) do
        headline     "headline"
        description1 "description1"
        description2 "description2"
      end

      text_ad.id.should == 10
      text_ad.headline.should     == "headline"
      text_ad.description1.should == "description1"
      text_ad.description2.should == "description2"
      text_ad.status.should == "ENABLED"
    end

    it "should accepts a block (call)" do
      text_ad = AdGroupTextAd.new(@adgroup) do |a|
        a.headline     "headline"
        a.description1 "description1"
        a.description2 "description2"
      end

      text_ad.id.should == 10
      text_ad.headline.should     == "headline"
      text_ad.description1.should == "description1"
      text_ad.description2.should == "description2"
      text_ad.status.should == "ENABLED"
    end

    it "should change status" do
      text_ad = AdGroupTextAd.new(@adgroup) do
        headline     "headline"
        description1 "description1"
        description2 "description2"
      end
      text_ad.status.should == "ENABLED"
      text_ad.status "PAUSED"
      text_ad.status.should == "PAUSED"
    end

    it "should produce xml (input for google)" do
      text_ad = AdGroupTextAd.new(@adgroup) do
        headline     "Vieni da noi"
        description1 "vieni da noi"
        description2 "arivieni da noi"
        url          "http://www.pluto.com"
        display_url  "www.Pluto.com"
      end
      expected_xml = read_model("//operand", "services", "ad_group_ad_service", "mutate_add_text_ad-req.xml")
      text_ad.to_xml("operand").should xml_equivalent(expected_xml)
    end

  end

  describe AdGroupMobileAd do

    it "should accepts a block (instance_eval)" do
      mobile_ad = AdGroupMobileAd.new(@adgroup) do
        markup "HTML"
        carrier 'T-Mobile@US'
        carrier 'Verizon@US'
        image  do
          name       'image_192x53.jpg'
          data       MOBILE_IMAGE_DATA
          dimension  'SHRUNKEN: 192x53'
        end
      end
      mobile_ad.status.should == "ENABLED"
      mobile_ad.markups.should include(AdGroupMobileAd::HTML)
    end

    it "should accepts a block (call)" do
      mobile_ad = AdGroupMobileAd.new(@adgroup) do |a|
        a.markup "HTML"
        a.carrier 'T-Mobile@US'
        a.carrier 'Verizon@US'
        a.image  do
          name       'image_192x53.jpg'
          data       MOBILE_IMAGE_DATA
          dimension  'SHRUNKEN: 192x53'
        end
      end
      mobile_ad.status.should == "ENABLED"
      mobile_ad.markups.should include(AdGroupMobileAd::HTML)
    end

    it "should produce xml (input for google)" do
      mobile_ad = AdGroupMobileAd.new(@adgroup) do
        headline      "sem4r"
        description   "simply adwords"
        # markup        "XHTML"
        carrier       "Vodafone@IT"
        # carrier  'ALLCARRIERS'
        business_name "sem4r"
        country_code  "IT"
        phone_number  "0612345"
      end

      expected_xml = read_model("//operand", "services", "ad_group_ad_service", "mutate_add_mobile_ad-req.xml")
      mobile_ad.to_xml("operand").should xml_equivalent(expected_xml)
    end

    it "should parse xml (output from google)" do
      el = read_model("//ad", "services", "ad_group_ad_service", "get_mobile_ad-res.xml")
      ad = AdGroupAd.from_element(@adgroup, el)
      ad.headline.should == "sem4r"
    end

  end

end
