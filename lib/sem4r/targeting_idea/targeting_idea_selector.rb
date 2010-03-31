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

module Sem4r

  class RelatedToKeywordSearchParameter
    include SoapAttributes

    g_accessor :text
    g_accessor :match_type

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_xml
      <<-EOS
          <s:searchParameters xsi:type="s:RelatedToKeywordSearchParameter">
            <s:keywords xsi:type="Keyword">
              <Criterion.Type>Keyword</Criterion.Type>
              <text>#{text}</text>
              <matchType>#{match_type}</matchType>
            </s:keywords>
          </s:searchParameters>
      EOS
    end
  end

  class ExcludedKeywordSearchParameter
    include SoapAttributes

    g_accessor :text
    g_accessor :match_type

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_xml
      <<-EOS
          <s:searchParameters xsi:type="s:ExcludedKeywordSearchParameter">
            <s:keywords xsi:type="Keyword">
              <Criterion.Type>Keyword</Criterion.Type>
              <text>#{text}</text>
              <matchType>#{match_type}</matchType>
            </s:keywords>
          </s:searchParameters>
      EOS
    end
  end

  class KeywordMatchTypeSearchParameter
    include SoapAttributes

    g_set_accessor :match_type

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_xml
      xml = ""
      xml << '<s:searchParameters xsi:type="s:KeywordMatchTypeSearchParameter">'
      match_types.each do |t|
        xml << "<s:keywordMatchTypes>#{t}</s:keywordMatchTypes>"
      end
      xml << '</s:searchParameters>'
    end
  end

  class CountryTargetSearchParameter
    include SoapAttributes

    g_set_accessor :country_code

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_xml
      xml = ""
      xml << '<s:searchParameters xsi:type="s:CountryTargetSearchParameter">'
      country_codes.each do |t|
        # tag contryCode is into the cm namespace (sem4r main namespace)
        # tag contryTarget is into o namespace (sem4r service namespace)
        xml << "<s:countryTargets><countryCode>#{t}</countryCode></s:countryTargets>"
      end
      xml << '</s:searchParameters>'
    end
  end
  
  class NgramGroupsSearchParameter
    include SoapAttributes

    g_set_accessor :ngram

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_xml
      xml = ""
      xml << '<s:searchParameters xsi:type="s:NgramGroupsSearchParameter">'
      ngrams.each do |t|
        xml << "<s:ngramGroups>#{t}</s:ngramGroups>"
      end
      xml << '</s:searchParameters>'
    end
  end
  
  class TargetingIdeaSelector
    include SoapAttributes

    enum :IdeaTypes, [:KEYWORD, :PLACEMENT]
    enum :RequestTypes, [:IDEAS, :STATS]

    g_accessor :idea_type, { :values_in => :IdeaTypes }
    g_accessor :request_type
    g_accessor :requested_attributes
    g_accessor :start_index
    g_accessor :number_results

    def initialize(&block)
      @search_parameters = []
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    # TODO: synthetize following methods with metaprogramming
    def related_to_keyword_search_parameter(&block)
      @search_parameters << RelatedToKeywordSearchParameter.new(&block)
    end

    def excluded_keyword_search_parameter(&block)
      @search_parameters << ExcludedKeywordSearchParameter.new(&block)
    end

    def keyword_match_type_search_parameter(&block)
      @search_parameters << KeywordMatchTypeSearchParameter.new(&block)
    end

    def country_target_search_parameter(&block)
      @search_parameters << CountryTargetSearchParameter.new(&block)
    end
    
    def ngram_group_search_parameter(&block)
      @search_parameters << NgramGroupsSearchParameter.new(&block)
    end

    def to_xml
      xml=<<-EOFS
       <s:selector>
          <s:ideaType>#{@idea_type}</s:ideaType>
          <s:requestType>#{@request_type}</s:requestType>
      EOFS
      xml += @search_parameters.collect{ |sp| sp.to_xml }.join()
      if requested_attributes
        requested_attributes.each do |requested_attribute|
          xml += <<-EOS
            <s:requestedAttributeTypes>#{requested_attribute.to_s.upcase}</s:requestedAttributeTypes>
          EOS
        end
      end
      xml+=<<-EOFS
        <s:paging>
          <startIndex>#{start_index || 0}</startIndex>
          <numberResults>#{number_results || 100}</numberResults>
        </s:paging>
        </s:selector>
      EOFS
      xml

    end
    #      <n3:selector>
    #
    #        <n3:ideaType>KEYWORD</n3:ideaType>
    #        <n3:requestType>IDEAS</n3:requestType>
    #
    #
    #
    #
    #        <n3:paging xmlns:n6="https://adwords.google.com/api/adwords/cm/v200909">
    #          <n6:startIndex>0</n6:startIndex>
    #          <n6:numberResults>100</n6:numberResults>
    #        </n3:paging>
    #
    #      </n3:selector>
    #

    ##########################################################################

  end
end
