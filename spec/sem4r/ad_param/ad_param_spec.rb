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

describe AdParam do

  include Sem4rSpecHelper

  before(:each) do
    services = stub("services")
    stub_service_ad_param(services)
    # stub_service_ad_group_criterion(services)
    # stub_service_ad_group_ad(services)
    @adgroup   = stub_adgroup(services)
    @criterion = stub_criterion(services)
  end
 
  it "should accepts a block" do
    ad_param = AdParam.new(@adgroup, @criterion) do
      index  1
      text   "testo"
    end
    ad_param.index.should == 1
    ad_param.text.should  == "testo"
  end

  it "should parse xml" do
    @adgroup.should_receive(:find_criterion).with(100).and_return(@criterion)
    el = read_model("//xmlns:rval", "services", "ad_param", "mutate_set-res.xml")
    ad_param = AdParam.from_element(@adgroup, el)
    ad_param.index.should == 1
    ad_param.text.should  == "$99.99"
  end

end

 
