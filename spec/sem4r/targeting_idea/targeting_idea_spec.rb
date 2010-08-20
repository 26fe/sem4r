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

describe TargetingIdea do
  include Sem4rSpecHelper, AggregatesSpecHelper

  it "should parse xml (produced by google)" do
    el = read_model("//ns2:entries", "services", "targeting_idea", "get-res.xml")
    idea = TargetingIdea.from_element(el)
    idea.should have(2).attributes
  end

  describe TKeywordAttribute do
    it "should parse xml (produced by google)" do
      el = read_model("//ns2:value", "services", "targeting_idea", "get-res.xml")
      attr = TKeywordAttribute.from_element(el)
      attr.text.should == "sample keyword"
      attr.match_type.should  == "EXACT"
    end
  end

  describe TIdeaTypeAttribute do
    it "should parse xml (produced by google)" do
      el = read_model("//ns2:value[@xsi:type='ns2:IdeaTypeAttribute']", "services", "targeting_idea", "get-res.xml")
      attr = TIdeaTypeAttribute.from_element(el)
      attr.value.should == "KEYWORD"
    end
  end

end
