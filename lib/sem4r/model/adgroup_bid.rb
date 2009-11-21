module Sem4r
  class AdgroupBid

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