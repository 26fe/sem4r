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
  class AdGroupBids
    include SoapAttributes

    enum :Types, [
      :BudgetOptimizerAdGroupBids,
      :ConversionOptimizerAdGroupBids,
      :ManualCPCAdGroupBids,
      :ManualCPMAdGroupBids]

    # g_accessor :type

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element(el)
      type =  el.elements["AdGroupBids.Type"].text.strip
      klass = Module::const_get(type)
      klass.from_element(el)
    end

    def to_s
      "#{@maxcpc / 10000} cents"
    end
  end

  class BudgetOptimizerAdGroupBids < AdGroupBids
  end

  class ConversionOptimizerAdGroupBids < AdGroupBids
  end

  class ManualCPCAdGroupBids < AdGroupBids

    g_accessor :keyword_max_cpc
    g_accessor :site_max_cpc

    def xml(t)
      return "" unless @keyword_max_cpc or @site_max_cpc
      t.tag!('bids', 'xsi:type' => 'ManualCPCAdGroupBids') { |xml|
        xml.tag!('AdGroupBids.Type') { xml.text! 'ManualCPCAdGroupBids' }

        if @keyword_max_cpc
          xml.keywordMaxCpc {
            xml.amount {
              xml.tag!('ComparableValue.Type') { xml.text! 'Money' }
              xml.microAmount keyword_max_cpc
            }
          }
        end

        if @site_max_cpc
          xml.siteMaxCpc {
            xml.amount {
              xml.tag!('ComparableValue.Type') { xml.text! 'Money' }
              xml.microAmount site_max_cpc
            }
          }
        end
      }
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new unless builder
      xml(builder)
      #      xml = builder.tag!('bids', 'xsi:type' => 'ManualCPCAdGroupBids') { |xml|
      #        xml.tag!('AdGroupBids.Type') { xml.text! 'ManualCPCAdGroupBids' }
      #
      #        if @keyword_max_cpc
      #          xml.keywordMaxCpc {
      #            xml.amount {
      #              xml.tag!('ComparableValue.Type') { xml.text! 'Money' }
      #              xml.microAmount keyword_max_cpc
      #            }
      #          }
      #        end
      #
      #        if @site_max_cpc
      #          xml.siteMaxCpc {
      #            xml.amount {
      #              xml.tag!('ComparableValue.Type') { xml.text! 'Money' }
      #              xml.microAmount site_max_cpc
      #            }
      #          }
      #        end
      #      }
    end

    def self.from_element(el)
      new do
        kel = el.elements["keywordMaxCpc"]
        if kel
          el_amount = kel.elements["amount"]
          keyword_max_cpc     el_amount.elements["microAmount"].text.to_i
        end
        sel = el.elements["siteMaxCpc"]
        if sel
          el_amount = sel.elements["amount"]
          site_max_cpc     el_amount.elements["microAmount"].text.to_i
        end
        # TODO: it is possible something like:
        #        el.elements["maxCpc"] do |el|
        #          el.elements["amount"] do el
        #            max_cpc el["microAmount"]
        #          end
        #        end
      end
    end
  end

  class ManualCPMAdGroupBids < AdGroupBids
    g_accessor :max_cpm

    def xml(t)
      return "" unless @max_cpm
      t.tag!('bids', 'xsi:type' => 'ManualCPMAdGroupBids') { |xml|
        xml.tag!('AdGroupBids.Type') { xml.text! 'ManualCPMAdGroupBids' }
        xml.maxCpm {
          xml.amount {
            xml.tag!('ComparableValue.Type') { xml.text! 'Money' }
            xml.microAmount max_cpm
          }
        }
      }
    end

    def to_xml(builder = nil)
      builder = Builder::XmlMarkup.new unless builder
      xml(builder)
    end

    def self.from_element(el)
      new do
        kel = el.elements["maxCpm"]
        if kel
          el_amount = kel.elements["amount"]
          max_cpm     el_amount.elements["microAmount"].text.to_i
        end
      end
    end

  end

end
