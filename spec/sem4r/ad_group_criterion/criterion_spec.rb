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


describe Criterion do
  include Sem4rSpecHelper

  before do
    services = stub("services")
    stub_service_ad_group_criterion(services)
    @ad_group = stub_adgroup(services)
  end

  describe CriterionKeyword do

    it "should accept a block" do
      keyword = CriterionKeyword.new(@ad_group) do
        text       "pippo"
        match      "BROAD"
      end
      keyword.text.should  == "pippo"
      keyword.match.should == "BROAD"
    end

    it "should produce xml (input for google)" do
      keyword = CriterionKeyword.new(@ad_group) do
        text       "sem4r adwords api"
        match      "BROAD"
      end
      xml_expected = read_model("//criterion", "ad_group_criterion", "mutate_add_criterion_keyword-req.xml")
      keyword.to_xml("criterion").should  xml_equivalent(xml_expected)
    end

    it "should parse xml (produced by google)" do
      el = read_model("//entries/criterion", "ad_group_criterion", "get-res.xml")
      keyword = CriterionKeyword.from_element(@ad_group, el)
      keyword.text.should == "pippo"
      keyword.match.should == "BROAD"
    end

  end

  describe CriterionPlacement do

    it "should accept a block" do
      keyword = CriterionPlacement.new(@ad_group) do
        url       "http://github.com"
      end
      keyword.url.should  == "http://github.com"
    end

    it "should parse xml (produced by google)" do
      el = read_model("//criterion", "ad_group_criterion", "mutate_add_criterion_placement-res.xml")
      placement = CriterionPlacement.from_element(@ad_group, el)
      placement.id.should == 11536085
      placement.url.should == "github.com"
    end

  end

end
