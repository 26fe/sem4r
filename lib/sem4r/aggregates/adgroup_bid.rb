# -------------------------------------------------------------------
# Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
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
  class AdgroupBid
    include SoapAttributes


    #
    # enum type
    #
    BudgetOptimizer     = "BudgetOptimizerAdGroupBids"
    ConversionOptimizer = "ConversionOptimizerAdGroupBids"
    CPC                 = "ManualCPCAdGroupBids"
    CPM                 = "ManualCPMAdGroupBids"


    def initialize(&block)
      instance_eval(&block) if block_given?
    end

   
    #      <bids xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ManualCPCAdGroupBids">
    #          <AdGroupBids.Type>ManualCPCAdGroupBids</AdGroupBids.Type>
    #          <keywordMaxCpc>
    #              <amount>
    #                  <ComparableValue.Type>Money</ComparableValue.Type>
    #                  <microAmount>10000000</microAmount>
    #              </amount>
    #          </keywordMaxCpc>
    #      </bids>
    def self.from_element(el)
      new do
        type           el.elements["AdGroupBids.Type"].text
        maxcpc         REXML::XPath.match( el, "//microAmount" ).first.text.to_i
      end
    end

    def to_s
      "#{@maxcpc / 10000} cents"
    end

    ##########################################################################

    def type=(value)
      @type=value
    end

    def type(value = nil)
      value ? self.type = value : @type
    end

    def maxcpc=(value)
      @maxcpc=value
    end

    def maxcpc(value = nil)
      value ? self.maxcpc = value : @maxcpc
    end

  end
end
