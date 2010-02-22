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
    mock_service_ad_group_criterion(services)
    mock_service_ad_group_ad(services)
    @adgroup = adgroup_mock(services, 3060217927)
  end

  describe AdGroupAd do

    it "should parse xml" do
      el = read_model("//ad", "services", "ad_group_ad_service", "get-res.xml")
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
    end
  
    it "should accepts a block" do
      text_ad = AdGroupTextAd.new(@adgroup) do
        headline     "headline"
        description1 "description1"
        description2 "description2"
      end

      text_ad.id.should == 10
      text_ad.headline.should     == "headline"
      text_ad.description1.should == "description1"
      text_ad.description2.should == "description2"
    end

    it "shoud produce xml" do
      text_ad = AdGroupTextAd.new(@adgroup) do
        headline     "Vieni da noi"
        description1 "vieni da noi"
        description2 "arivieni da noi"
        url          "http://www.pluto.com"
        display_url  "www.Pluto.com"
      end
      expected_xml = read_model("//operand", "services", "ad_group_ad_service", "mutate_add-req.xml")
      # puts text_ad.to_xml("operand")
      text_ad.to_xml("operand").should xml_equivalent(expected_xml)
    end

  end

  describe AdGroupMobileAd do

    it "should accepts a block" do
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
      mobile_ad.markups.should include(AdGroupMobileAd::HTML)
    end

  end

end
