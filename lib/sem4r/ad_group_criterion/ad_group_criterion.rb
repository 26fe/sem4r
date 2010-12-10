# -*- coding: utf-8 -*-
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

  #
  # http://code.google.com/apis/adwords/v2009/docs/reference/AdGroupCriterionService.AdGroupCriterion.html
  #
  class AdGroupCriterion
    include Sem4rSoap::SoapAttributes
    
    g_accessor :criterion

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element(ad_group, el)
      type =  el.at_xpath("AdGroupCriterion.Type").text.strip
      klass = Module::const_get(type)
      klass.from_element(ad_group, el)
    end

    def saved?
      criterion.saved?
    end

    def save
      unless criterion.saved?
        o = AdGroupCriterionOperation.new.add(self)
        soap_message =
          criterion.service.ad_group_criterion.mutate( credentials, o.to_xml("operations") )
        criterion.add_counters( soap_message.counters )
        rval = soap_message.response.xpath("//mutateResponse/rval").first
        id = rval.xpath("value/criterion/id").first
        criterion.instance_eval{ @id = id.text.strip.to_i }
      end
      self
    end

  end

  class BiddableAdGroupCriterion < AdGroupCriterion

    g_accessor :bids

    def initialize(ad_group, &block)
      @ad_group = ad_group
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_s
      "biddable " + criterion.to_s
    end

    def self.from_element(ad_group, el)
      new(ad_group) do
        criterion Criterion.from_element(ad_group, el.at_xpath("criterion"))
        bids      AdGroupCriterionBids.from_element(el.at_xpath("bids"))
      end
    end

    def _xml(t)
      t.adGroupId   @ad_group.id
      # t.status "ENABLED"
      criterion.xml(t)
      @bids.xml(t) if @bids
    end

    def xml(t, tag = nil)
      if tag
        t.__send__(tag, {"xsi:type" => "BiddableAdGroupCriterion"}) { |t| _xml(t) }
      else
        _xml(t)
      end
    end

    def to_xml(tag)
      xml(Builder::XmlMarkup.new, tag)
    end

  end

  class NegativeAdGroupCriterion < AdGroupCriterion

    def initialize(ad_group, &block)
      @ad_group = ad_group
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def to_s
      "negative " + criterion.to_s
    end

    def self.from_element(ad_group, el)
      new(ad_group) do
        criterion Criterion.from_element(ad_group, el.at_xpath("criterion"))
      end
    end

    # @private
    #
    #
    def _xml(t)
      t.adGroupId   criterion.ad_group.id
      # t.status "ENABLED"
      criterion.xml(t)
    end

    def xml(t, tag = nil)
      if tag
        t.__send__(tag, {"xsi:type" => "NegativeAdGroupCriterion"}) { |t| _xml(t) }
      else
        _xml(t)
      end
    end

    def to_xml(tag)
      xml(Builder::XmlMarkup.new, tag)
    end


  end

end
