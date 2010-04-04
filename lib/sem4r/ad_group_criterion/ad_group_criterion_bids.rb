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

  class AdGroupCriterionBids
    include SoapAttributes

    enum :Types, [
      :BudgetOptimizerAdGroupCriterionBids,
      :ConversionOptimizerAdGroupCriterionBids,
      :ManualCPCAdGroupCriterionBids,
      :ManualCPMAdGroupCriterionBids
    ]

    def self.from_element(el)
      type =  el.elements["AdGroupCriterionBids.Type"].text.strip
      klass = Module::const_get(type)
      klass.from_element(el)
    end
  end

  class BudgetOptimizerAdGroupCriterionBids < AdGroupCriterionBids
  end

  class ConversionOptimizerAdGroupCriterionBids < AdGroupCriterionBids
  end

  #
  # http://code.google.com/apis/adwords/v2009/docs/reference/AdGroupCriterionService.ManualCPCAdGroupCriterionBids.html
  #
  class ManualCPCAdGroupCriterionBids < AdGroupCriterionBids

    g_accessor :bid_source
    g_accessor :max_cpc

    def initialize(&block)
      if block_given?
        instance_eval(&block)
      end
    end

    def self.from_element(el)
      new do
        bid_source       el.elements["bidSource"].text.strip

        el_maxCpc = el.elements["maxCpc"]
        el_amount = el_maxCpc.elements["amount"]
        max_cpc     el_amount.elements["microAmount"].text.strip.to_i

        # TODO: it is possible something like:
        #        el.elements["maxCpc"] do |el|
        #          el.elements["amount"] do el
        #            max_cpc el["microAmount"]
        #          end
        #        end
      end
    end

    def xml(t)
      t.tag!('bids', 'xsi:type' => 'ManualCPCAdGroupCriterionBids') {
        t.tag!('AdGroupCriterionBids.Type') { t.text! 'ManualCPCAdGroupCriterionBids' }
        t.maxCpc {
          t.amount {
            t.tag!('ComparableValue.Type') { t.text! 'Money' }
            t.microAmount max_cpc
          }
        }
      }
    end

    def to_xml(tag = 'bids')
      builder = Builder::XmlMarkup.new
      xml = builder.tag!(tag, 'xsi:type' => 'ManualCPCAdGroupCriterionBids') { |xml|
        xml.tag!('AdGroupCriterionBids.Type') { xml.text! 'ManualCPCAdGroupCriterionBids' }
        xml.maxCpc {
          xml.amount {
            xml.tag!('ComparableValue.Type') { xml.text! 'Money' }
            xml.microAmount max_cpc
          }
        }
      }
    end

    def to_s
      "#{@maxcpc / 10000} cents"
    end

  end

  class ManualCPMAdGroupCriterionBids < AdGroupCriterionBids
  end

end
