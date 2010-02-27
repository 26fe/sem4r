# -------------------------------------------------------------------
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
# -------------------------------------------------------------------

module Sem4r

  class Criterion < Base

    enum :Types,             [:Keyword, :Placement]
    enum :KeywordMatches,    [:EXACT, :BROAD, :PHRASE]

    attr_reader :id
    attr_reader :ad_group
    attr_accessor :type

    def initialize( ad_group )
      super( ad_group.adwords, ad_group.credentials )
      @ad_group = ad_group
    end

    def self.from_element( ad_group, el )
      xml_type =       el.elements["Criterion.Type"].text
      case xml_type
      when Keyword
        CriterionKeyword.from_element(ad_group, el)
      when Placement
        CriterionPlacement.from_element(ad_group, el)
      end
    end

    ############################################################################
    # ad params management

    def ad_param(&block)
      save
      ad_param = AdParam.new(ad_group, self, &block)
      @ad_params ||= []
      @ad_params << ad_param
      ad_param
    end

    def bids

    end

  end
end
