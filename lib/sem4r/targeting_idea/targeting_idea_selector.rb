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

module Sem4r
  class SearchParameterBase
    def self.xml(&block)
      return @__xml__ unless block_given?
      @__xml__ = block
    end

    def self.inherited(klass)
      klass.send :include, Sem4rSoap::SoapAttributes
    end

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_xml
      name = self.class.name.split("::").last
      xml  = "<s:searchParameters xsi:type='s:#{name}'>"
      xml  += instance_eval(&self.class.xml)
      xml  += "</s:searchParameters>"
    end
  end

  class TargetingIdeaSelector
    include Sem4rSoap::SoapAttributes

    class << self
      def search_parameter(pname, &block)
        class_name = pname.to_s.split("_").map { |e| e.capitalize }.join + "SearchParameter"
        klass      = Sem4r.const_set(class_name, Class.new(SearchParameterBase))
        klass.instance_eval &block

        class_eval <<-EOS
          def #{pname}_search_parameter(&block)
            @search_parameters << #{class_name}.new(&block)
          end
        EOS
      end
    end

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

    def to_xml
      xml=<<-EOFS
       <s:selector>
          <s:ideaType>#{@idea_type}</s:ideaType>
          <s:requestType>#{@request_type}</s:requestType>
      EOFS
      xml += @search_parameters.collect { |sp| sp.to_xml }.join()
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

    search_parameter :related_to_keyword do
      g_set_accessor :text
      g_accessor :match_type

      xml do
        texts.map do |t|
          <<-EOS
            <s:keywords xsi:type="Keyword">
              <Criterion.Type>Keyword</Criterion.Type>
              <text>#{t}</text>
              <matchType>#{match_type}</matchType>
            </s:keywords>
          EOS
        end.join
      end
    end

    search_parameter :related_to_url do
      g_set_accessor :url

      xml do
        urls.map { |u| "<s:urls>#{u}</s:urls>" }.join
      end
    end

    search_parameter :excluded_keyword do
      g_accessor :text
      g_accessor :match_type

      xml do
        <<-EOS
          <s:keywords xsi:type="Keyword">
            <Criterion.Type>Keyword</Criterion.Type>
            <text>#{text}</text>
            <matchType>#{match_type}</matchType>
          </s:keywords>
        EOS
      end
    end

    search_parameter :keyword_match_type do
      g_set_accessor :match_type

      xml do
        match_types.map do |mt|
          "<s:keywordMatchTypes>#{mt}</s:keywordMatchTypes>"
        end.join
      end
    end

    search_parameter :country_target do
      g_set_accessor :country_code

      xml do
        country_codes.map do |cc|
          "<s:countryTargets><countryCode>#{cc}</countryCode></s:countryTargets>"
        end.join
      end
    end

  end
end
