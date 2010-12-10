# -*- coding: utf-8 -*-
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
  class BulkMutateJob
    include Sem4rSoap::SoapAttributes

    attr_reader :id
    attr_accessor :campaign_id
    attr_reader :operations
    attr_accessor :num_parts

    g_accessor :status

    def initialize(&block)
      @operations = []
      @num_parts  = 1
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def add_operation(operation)
      @operations << operation
      self
    end

    def empty?
      @operations.empty?
    end

    def add(something)
      case something
        when AdGroupTextAd
          ad_operation = AdGroupAdOperation.add something
        else
          raise "how you suppose I must do when incounter a #{something.class}?"
      end
      self
    end

    #
    # @private
    #
    def _xml(t)
      if @id
        t.id id
      else
        t.request do |t|
          t.partIndex 0

          t.operationStreams do |t|
            t.scopingEntityId do |t|
              t.type "CAMPAIGN_ID"
              t.value campaign_id
            end
            @operations.each { |operation| operation.xml(t, "operations") } if @operations
          end
        end
        t.numRequestParts num_parts
      end
    end

    #
    # Marshal to xml using Builder
    # @parm [Builder::XmlBuilder]
    #
    def xml(t, tag = nil)
      if tag
        t.__send__(tag, {"xsi:type"=>'BulkMutateJob'}) { |t| _xml(t) }
      else
        _xml(t)
      end
    end

    def to_xml(tag = "operand")
      xml(Builder::XmlMarkup.new, tag)
    end

    def self.from_element(el)
      new do
        @id = el.at_xpath("id").text.strip.to_i
        status el.at_xpath("status").text
      end
    end

    def to_s
      "#{@id} #{status}"
    end

  end

end