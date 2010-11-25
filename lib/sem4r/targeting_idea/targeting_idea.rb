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


  class TargetingIdea
    include SoapAttributes

    enum :AttributeTypes, [
      :AdFormatSpecListAttribute,
      :BooleanAttribute,
      :DoubleAttribute,
      :IdeaTypeAttribute,
      :InStreamAdInfoAttribute,
      :IntegerAttribute,
      :IntegerSetAttribute,
      :LongAttribute,
      :MonthlySearchVolumeAttribute,
      :PlacementTypeAttribute,
      :StringAttribute,
      :WebpageDescriptorAttribute,
      :KeywordAttribute,
      :MoneyAttribute,
      :PlacementAttribute,
      :LongRangeAttribute,
      :MonthlySearchVolumeAttribute]

    attr_reader :attributes
    
    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element(el)
      els = el.xpath("data")
      @attributes = els.map do |el|
        el1 = el.at_xpath("value")
        xml_type = el1.at_xpath("Attribute.Type").text.strip
        case xml_type
        when IdeaTypeAttribute
          TIdeaTypeAttribute.from_element(el1)
        when KeywordAttribute
          TKeywordAttribute.from_element(el1)
        when MonthlySearchVolumeAttribute
          TMonthlySearchVolumeAttribute.from_element(el1)
        end
      end
    end

    def to_s
      @attributes.collect { |attr| attr.to_s }.join("\n")
    end

  end

  class TKeywordAttribute
    include SoapAttributes

    g_accessor :text
    g_accessor :match_type

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element( el )
      el1 = el.at_xpath("value")
      new do
        text       el1.at_xpath("text").text
        match_type el1.at_xpath("matchType").text
      end
    end

    def to_s
      "Keyword '#{text}' '#{match_type}'"
    end
  end
  
  class TMonthlySearchVolumeAttribute
    include SoapAttributes

    g_accessor :text
    g_accessor :values

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element( el )
      historical_values = []
      el.children.each do |node|
        next if node.name == "Attribute.Type"
        historical_value = { :year => node.at_xpath("year").text,
          :month => node.at_xpath("month").text}
        historical_value.merge!(:count => node.at_xpath("count").text) if node.at_xpath("count")
        historical_values << historical_value
      end
      new do
        values historical_values
      end
    end

    def to_s
      "Values: #{values.inspect}"
    end
  end

  class TIdeaTypeAttribute
    include SoapAttributes

    g_accessor :value

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element( el )
      new do
        value       el.at_xpath("value").text
      end
    end

    def to_s
      "Idea '#{value}'"
    end
  end

end
