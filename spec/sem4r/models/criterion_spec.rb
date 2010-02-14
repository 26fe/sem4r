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


describe Criterion do

  include Sem4rSpecHelper

  before do
    services = stub("services")
    mock_service_ad_group_criterion(services)
    @adgroup = adgroup_mock(services)
  end

  describe CriterionKeyword do

    it "should accept a block" do
      keyword = CriterionKeyword.new(@adgroup) do
        text       "pippo"
        match      "BROAD"
      end
      keyword.text.should  == "pippo"
      keyword.match.should == "BROAD"
      keyword.id.should    == 10
    end

    it "should parse xml" do
      el = read_model("//entries/criterion", "services", "ad_group_criterion_service", "get-res.xml")
      keyword = CriterionKeyword.from_element(@adgroup, el)
      keyword.id.should == 11536082
      keyword.text.should == "pippo"
      keyword.match.should == "BROAD"
    end

  end

  describe CriterionPlacement do

    it "should accept a block" do
      keyword = CriterionPlacement.new(@adgroup) do
        url       "http://github.com"
      end
      keyword.url.should  == "http://github.com"
      keyword.id.should    == 10
    end

    it "should parse xml" do
      el = read_model("//criterion", "services", "ad_group_criterion_service", "mutate_add_criterion_placement-res.xml")
      placement = CriterionPlacement.from_element(@adgroup, el)
      placement.id.should == 11536085
      placement.url.should == "github.com"
    end

  end

end
