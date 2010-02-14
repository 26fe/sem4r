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


describe AdGroup do

  include Sem4rSpecHelper

  before do
    services = stub("services")
    mock_service_ad_group(services)
    mock_service_ad_group_criterion(services)
    mock_service_ad_group_ad(services)
    mock_service_ad_param(services)
    @campaign = mock_campaign(services)
    @criterion = criterion_mock(services)
  end

  describe "adgroup management" do

    it "create should accept a block" do
      adgroup = AdGroup.create(@campaign) do
        name "adgroup"
      end

      adgroup.name.should  == "adgroup"
      adgroup.id.should    == 10
    end

    it "should parse xml" do
      # el = load_model_xml("ad_group")
      el = read_model("//entries", "services", "ad_group_service", "get-res.xml")

      adgroup = AdGroup.from_element(@campaign, el)
      adgroup.id.should == 3060217923
      adgroup.name.should == "test adgroup"
      adgroup.status.should == "ENABLED"
    end

  end

  describe "ad management" do

    it "should create a TextAd with a block" do
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        text_ad do
          url           "http://www.pluto.com"
          display_url   "www.Pluto.com"
          headline      "Vieni da noi"
          description1  "vieni da noi"
          description2  "arivieni da noi"
        end
      end

      adgroup.ads.length.should   == 1
      adgroup.ads.first.id.should == 10
    end

  end

  describe "criterion management" do

    it "should add a CriterionKeyword with method 'keyword' + block" do
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        keyword do
          text "pippo"
          match "BROAD"
        end
      end
      adgroup.criterions.length.should   == 1
      criterion = adgroup.criterions.first
      criterion.id.should == 10
      criterion.text.should == "pippo"
    end

    it "should add a CriterionKeyword with method 'keyword' + parameters" do
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        keyword "pippo", "BROAD"
      end
      adgroup.criterions.length.should   == 1
      criterion = adgroup.criterions.first
      criterion.id.should == 10
      criterion.text.should == "pippo"
    end
    
    it "should add a CriterionPlacement with method 'placement' + block" do
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        placement do
          url "pippo"
        end
      end
      adgroup.criterions.length.should   == 1
      criterion = adgroup.criterions.first
      criterion.id.should == 10
      criterion.url.should == "pippo"
    end

    it "should add a CriterionPlacement with method 'placement' + parameters" do
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        placement "url"
      end
      adgroup.criterions.length.should   == 1
      criterion = adgroup.criterions.first
      criterion.id.should == 10
      criterion.url.should == "url"
    end
  end

  describe "ad_param management" do

    it "should create a AdParam with method 'ad_param' + block" do
      criterion = @criterion # it is necessary to pass to following block
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        ad_param(criterion) do
          index 1
          text  "$99.99"
        end
      end

      adgroup.ad_params.length.should   == 1
      param = adgroup.ad_params.first
      param.index.should == 1
      param.text.should == "$99.99"
    end

    it "should create a AdParam with method 'ad_param' + param" do
      criterion = @criterion # it is necessary to pass to following block
      adgroup = AdGroup.new(@campaign) do
        name "adgroup"
        ad_param criterion, 1, "$99.99"
      end

      adgroup.ad_params.length.should   == 1
      param = adgroup.ad_params.first
      param.index.should == 1
      param.text.should == "$99.99"
    end
  end

end
