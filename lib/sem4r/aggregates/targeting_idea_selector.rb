# -------------------------------------------------------------------------
# Copyright (c) 2009 Sem4r sem4ruby@gmail.com
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
  class TargetingIdeaSelector
    include SoapAttributes

    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def to_xml
      <<-EOFS
       <s:selector>
          <s:ideaType>#{@idea_type}</s:ideaType>
          <s:requestType>#{@request_type}</s:requestType>

          <s:searchParameters xsi:type="s:RelatedToKeywordSearchParameter">
            <s:keywords xsi:type="Keyword">
              <Criterion.Type>Keyword</Criterion.Type>
              <text>pippo</text>
              <matchType>EXACT</matchType>
            </s:keywords>
          </s:searchParameters>
        <s:paging>
          <startIndex>0</startIndex>
          <numberResults>100</numberResults>
        </s:paging>

        </s:selector>
      EOFS
    end
#      <n3:selector>
#
#        <n3:searchParameters xsi:type="n3:ExcludedKeywordSearchParameter">
#          <n3:keywords xmlns:n4="https://adwords.google.com/api/adwords/cm/v200909"
#              xsi:type="n4:Keyword">
#            <n4:text>media player</n4:text>
#            <n4:matchType>EXACT</n4:matchType>
#          </n3:keywords>
#        </n3:searchParameters>
#
#        <n3:searchParameters xsi:type="n3:KeywordMatchTypeSearchParameter">
#          <n3:keywordMatchTypes>BROAD</n3:keywordMatchTypes>
#          <n3:keywordMatchTypes>EXACT</n3:keywordMatchTypes>
#        </n3:searchParameters>
#        <n3:searchParameters xsi:type="n3:RelatedToKeywordSearchParameter">
#          <n3:keywords xmlns:n5="https://adwords.google.com/api/adwords/cm/v200909"
#              xsi:type="n5:Keyword">
#            <n5:text>dvd player</n5:text>
#            <n5:matchType>EXACT</n5:matchType>
#          </n3:keywords>
#        </n3:searchParameters>
#        <n3:ideaType>KEYWORD</n3:ideaType>
#        <n3:requestType>IDEAS</n3:requestType>
#        <n3:paging xmlns:n6="https://adwords.google.com/api/adwords/cm/v200909">
#          <n6:startIndex>0</n6:startIndex>
#          <n6:numberResults>100</n6:numberResults>
#        </n3:paging>
#      </n3:selector>
#

    ##########################################################################

    enum :IdeaTypes, [:KEYWORD, :PLACEMENT]
    enum :RequestTypes, [:IDEAS, :STATS]


    g_accessor :idea_type, { :values_in => :IdeaTypes }
    g_accessor :request_type
#    g_set_accessor :search_parameter
  end
end
