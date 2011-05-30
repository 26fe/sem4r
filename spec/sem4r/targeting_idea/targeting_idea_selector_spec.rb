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
# -------------------------------------------------------------------------

require File.expand_path(File.dirname(__FILE__) + '/../../rspec_helper')

describe TargetingIdeaSelector do
  include Sem4rSpecHelper

  it "should produce xml (input for google)" do
    idea_selector = TargetingIdeaSelector.new do
      idea_type    "KEYWORD"
      request_type "IDEAS"
      requested_attributes %w{KEYWORD IDEA_TYPE KEYWORD_CATEGORY NGRAM_GROUP}

      excluded_keyword_search_parameter do
        text       'media player'
        match_type 'EXACT'
      end

      keyword_match_type_search_parameter do
        match_type 'BROAD'
        match_type 'EXACT'
      end

      related_to_keyword_search_parameter do
        ['dvd player', 'car stereo'].each do |term|
          text       term
          match_type 'EXACT'
        end
      end

      country_target_search_parameter do
        country_code 'US'
      end

    end

    xml_expected = read_model("//selector", "targeting_idea", "get-req.xml")
    idea_selector.to_xml.should  xml_equivalent(xml_expected)
  end

  it "should produce xml (input for google) with optional parameters" do
    idea_selector = TargetingIdeaSelector.new do
      idea_type    "KEYWORD"
      request_type "IDEAS"
      requested_attributes [:keyword, :targeted_monthly_searches]
      start_index 201
      number_results 200

      related_to_keyword_search_parameter do
        text       'dvd player'
        match_type 'EXACT'
      end
    end
    read_model("//requestedAttributeTypes", "targeting_idea", "get-01-req.xml") do |attribute_type|
      idea_selector.to_xml.should xml_contains(attribute_type)
    end
  end

  describe RelatedToKeywordSearchParameter do
    it "should produce xml (input for google)" do
      sp = RelatedToKeywordSearchParameter.new do
        ['dvd player', 'car stereo'].each do |term|
          text       term
          match_type 'EXACT'
        end
      end
      xml_expected = read_model("//searchParameters[@type='RelatedToKeywordSearchParameter']", "targeting_idea", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end

  describe ExcludedKeywordSearchParameter do
    it "should produce xml (input for google)" do
      sp = ExcludedKeywordSearchParameter.new do
        text "media player"
        match_type "EXACT"
      end
      xml_expected = read_model("//searchParameters[@type='ExcludedKeywordSearchParameter']", "targeting_idea", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end

  describe KeywordMatchTypeSearchParameter do
    it "should produce xml (input for google)" do
      sp = KeywordMatchTypeSearchParameter.new do
        match_type 'BROAD'
        match_type "EXACT"
      end
      xml_expected = read_model("//searchParameters[@type='KeywordMatchTypeSearchParameter']", "targeting_idea", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end

  describe CountryTargetSearchParameter do
    it "should produce xml (input for google)" do
      sp = CountryTargetSearchParameter.new do
        country_code 'US'
      end
      xml_expected = read_model("//searchParameters[@type='CountryTargetSearchParameter']", "targeting_idea", "get-req.xml")
      sp.to_xml.should  xml_equivalent(xml_expected)
    end
  end

end
