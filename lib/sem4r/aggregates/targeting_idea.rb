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

    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    #<data>
    #  <key>KEYWORD</key>
    #  <value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="KeywordAttribute">
    #    <Attribute.Type>KeywordAttribute</Attribute.Type>
    #    <value>
    #      <ns2:Criterion.Type>Keyword</ns2:Criterion.Type>
    #      <ns2:text>sample keyword 230527579 0</ns2:text>
    #      <ns2:matchType>EXACT</ns2:matchType>
    #    </value>
    #  </value>
    #</data>
    #<data>
    #  <key>IDEA_TYPE</key>
    #  <value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="IdeaTypeAttribute">
    #    <Attribute.Type>IdeaTypeAttribute</Attribute.Type>
    #    <value>KEYWORD</value>
    #  </value>
    #</data>
    def self.from_element(el)
      els = REXML::XPath.match( el, "data")
      els.each do |el|
        puts el.elements["key"].text

        el1 = el.elements["value"]
        xml_type =       el1.elements["Attribute.Type"].text
        case xml_type
        when IdeaTypeAttribute
          # puts el1.elements["value"].text
        when KeywordAttribute
          el2 = el1.elements["value"]
          puts el2.elements["text"].text
          puts el2.elements["matchType"].text
        end
      end
    end

    def to_s
      "#{@company_name} #{@address_line1} #{@address_line2} #{@city}"
    end

    ##########################################################################

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
      :LongRangeAttribute]

    g_accessor :company_name
    g_accessor :address_line1
    g_accessor :address_line2
    g_accessor :city
  end
end
