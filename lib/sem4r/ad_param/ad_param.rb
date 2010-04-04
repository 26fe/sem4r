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
  class AdParam < Base

    attr_reader :ad_group
    attr_reader :criterion

    g_accessor :index
    g_accessor :text

    def initialize(ad_group, criterion, index = nil, text = nil, &block)
      super( ad_group.adwords, ad_group.credentials )
      @ad_group   = ad_group
      @criterion  = criterion
      self.index = index unless index.nil?
      self.text  = text  unless text.nil?
      if block_given?
        instance_eval(&block)
        save
      end
    end

    def to_s
      "#{@id} #{@index} #{@text}"
    end


    # adGroupId  	   Id of ad_group This field is required and should not be null.
    # criterionId 	 The id of the Keyword criterion that this ad parameter applies to.
    #                The keyword must be associated with the same ad_group as this AdParam.
    #                This field is required and should not be null.
    # insertionText  Numeric value or currency value (eg. 15, $99.99) to insert into the ad text
    #                This field is required and should not be null when it is contained
    #                within Operators : SET. The length of this string should be
    #                between 1 and 25, inclusive.
    # paramIndex
    def to_xml
      <<-EOFS
        <adGroupId>#{@ad_group.id}</adGroupId>
        <criterionId>#{@criterion.id}</criterionId>
        <paramIndex>#{@index}</paramIndex>
        <insertionText>#{@text}</insertionText>
      EOFS
    end

    def self.from_element(ad_group, el)
      criterion_id = el.elements["criterionId"].text.strip.to_i
      criterion = ad_group.find_criterion(criterion_id)
      new(ad_group, criterion) do
        # ad_param don't have id so use @saved to indicate if readed from xml
        @saved = true
        index         el.elements["paramIndex"].text.strip.to_i
        text          el.elements["insertionText"].text.strip
      end
    end

    ############################################################################

    def save
      return if @saved
      soap_message = service.ad_param.set(credentials, to_xml)
      add_counters( soap_message.counters )
      # ignore response ad_param don't have id
      self
    end

  end
end




