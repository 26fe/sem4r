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

describe AdGroupAdOperation do

  before(:each) do
    @adgroup = mock("adgroup").as_null_object
    @ad_operation = AdGroupAdOperation.new
  end

  it "should raise missing operand" do
    @ad_operation.operator "ADD"
    @ad_operation.operator.should == "ADD"
    lambda {  @ad_operation.to_xml }.should raise_error(Sem4rError)
  end

  it "should produce xml" do
    @adgroup.should_receive(:id).and_return(10)
    text_ad = AdGroupTextAd.new(@adgroup)
    text_ad.headline     = "headline"
    text_ad.description1 = "description1"
    text_ad.description2 = "description2"
    @ad_operation.add text_ad
    @ad_operation.to_xml
  end

end
