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

describe TargetingIdeaSelector do
  include Sem4rSpecHelper, AggregatesSpecHelper

  it "should produce xml (input for google)" do
    idea_selector = TargetingIdeaSelector.new do
      idea_type    "KEYWORD"
      request_type "IDEAS"

      excluded_keyword_search_parameter do
        text       'media player'
        match_type 'EXACT'
      end

      keyword_match_type_search_parameter do
        match_type 'BROAD'
        match_type 'EXACT'
      end

      related_to_keyword_search_parameter do
        text       'dvd player'
        match_type 'EXACT'
      end
    end
    
    xml_expected = read_model("//s:selector", "services", "targeting_idea_service", "get-req.xml")
    idea_selector.to_xml.should  xml_equivalent(xml_expected)
  end

  describe RelatedToKeywordSearchParameter do
    it "should produce xml (input for google)" do
      sp = RelatedToKeywordSearchParameter.new do
        text "dvd player"
        match_type "EXACT"
      end
      xml_expected = read_model("//s:searchParameters[@xsi:type='s:RelatedToKeywordSearchParameter']", "services", "targeting_idea_service", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end

  describe ExcludedKeywordSearchParameter do
    it "should produce xml (input for google)" do
      sp = ExcludedKeywordSearchParameter.new do
        text "media player"
        match_type "EXACT"
      end
      xml_expected = read_model("//s:searchParameters[@xsi:type='s:ExcludedKeywordSearchParameter']", "services", "targeting_idea_service", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end

  describe KeywordMatchTypeSearchParameter do
    it "should produce xml (input for google)" do
      sp = KeywordMatchTypeSearchParameter.new do
        match_type 'BROAD'
        match_type "EXACT"
      end
      xml_expected = read_model("//s:searchParameters[@xsi:type='s:KeywordMatchTypeSearchParameter']", "services", "targeting_idea_service", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end


end
