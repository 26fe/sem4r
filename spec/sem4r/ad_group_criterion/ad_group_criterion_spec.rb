# -*- coding: utf-8 -*-
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


describe AdGroupCriterion do

  include Sem4rSpecHelper

  before do
    services = stub("services")
    stub_service_ad_group_criterion(services)
    @ad_group = stub_adgroup(services)
    @criterion = stub_criterion(services)
    @bids = stub("bids")
  end

  describe BiddableAdGroupCriterion do

    it "should be build with accessor (not a block)" do
      biddable_criterion = BiddableAdGroupCriterion.new(@ad_group)
      biddable_criterion.criterion @criterion
      biddable_criterion.bids @bids
      biddable_criterion.criterion.should  eql @criterion
      biddable_criterion.bids.should eql @bids
    end

    it "should produce xml (input for google)" do
      pending "move on api 201101"
      keyword = CriterionKeyword.new(@ad_group) do
        text       "sem4r adwords api"
        match      "BROAD"
      end
      bids = ManualCPCAdGroupCriterionBids.new
      bids.max_cpc 10000000

      biddable_criterion = BiddableAdGroupCriterion.new(@ad_group)
      biddable_criterion.criterion keyword
      biddable_criterion.bids bids

      xml_expected = read_model("//operand", "ad_group_criterion", "mutate_add_criterion_keyword-req.xml")
      biddable_criterion.to_xml("operand").should  xml_equivalent(xml_expected)
    end

    it "should parse xml (produced by google)" do
      el = read_model("//entries", "ad_group_criterion", "get-res.xml")
      biddable_criterion = BiddableAdGroupCriterion.from_element(@ad_group, el)
      biddable_criterion.bids.should be_instance_of(ManualCPCAdGroupCriterionBids)
      biddable_criterion.criterion.should be_instance_of(CriterionKeyword)
    end

  end

  describe NegativeAdGroupCriterion do

    it "should be build with accessors (not a block)" do
      biddable_criterion = NegativeAdGroupCriterion.new(@ad_group)
      biddable_criterion.criterion @criterion
      biddable_criterion.criterion.should  eql @criterion
    end

    it "should produce xml (input for google)" do
      keyword = CriterionKeyword.new(@ad_group) do
        text       "sem4r adwords api"
        match      "BROAD"
      end
      biddable_criterion = NegativeAdGroupCriterion.new(@ad_group)
      biddable_criterion.criterion keyword
      xml_expected = read_model("//operand", "ad_group_criterion", "mutate_add_negative_keyword-req.xml")
      biddable_criterion.to_xml("operand").should  xml_equivalent(xml_expected)
    end

    it "should parse xml (produced by google)" do
      el = read_model("//value", "ad_group_criterion", "mutate_add_negative_keyword-res.xml")
      negative = AdGroupCriterion.from_element(@ad_group, el)
      negative.criterion.text.should == "java api library"
      negative.criterion.match.should == "BROAD"
    end

  end

end
