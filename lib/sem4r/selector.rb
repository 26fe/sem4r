# -*- coding: utf-8 -*-
# -------------------------------------------------------------------------
# Copyright (c) 2009-2011 Sem4r sem4ruby@gmail.com
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

  class Predicate
    attr_reader :field, :operator, :values

    def initialize(field, operator, values)
      @field, @operator, @values = field, operator, values
    end

  end

  class Selector
    include Sem4rSoap::SoapAttributes

#    enum :UsageTypes, [
#      :FREE_USAGE_API_UNITS_PER_MONTH,
#      :UNIT_COUNT,
#      :TOTAL_USAGE_API_UNITS_PER_MONTH,
#      :OPERATION_COUNT,
#      :UNIT_COUNT_FOR_CLIENTS,
#      :METHOD_COST]
#
#    g_accessor :usage_type, :values_in => :UsageTypes
#    g_accessor :min
#    g_accessor :max

    g_set_accessor :field
    g_set_accessor :predicate

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

#    def to_xml
#      str = <<-EOFS
#        <selector>
#      EOFS
#      statuses.each do |s|
#        str += "<campaignStatuses>#{s}</campaignStatuses>"
#      end
#      str += <<-EOFS
#          <statsSelector>
#            <dateRange>
#              <min>20090101</min>
#              <max>20091231</max>
#            </dateRange>
#          </statsSelector>
#        </selector>
#      EOFS


#      <<EOS
#       <serviceSelector>
#         <fields>Id</fields>
#         <fields>Name</fields>
#         <fields>Status</fields>
#         <predicates>
#               <field>Status</field>
#               <operator>IN</operator>
#               <values>PAUSED</values>
#               <values>ACTIVE</values>
#         </predicates>
#       </serviceSelector>
#EOS
#
#    end

    # @private
    def _xml(t)
      t.serviceSelector do |t|
        if @fields
          @fields.each { |field| t.fields field }
        end
        if @predicates
          @predicates.each do |p|
            t.predicates do |t|
              t.field p.field
              t.operator p.operator
              p.values.each { |value| t.values value }
            end
          end
        end
      end
    end

    def xml(t, tag = nil)
      if tag
        t.__send__(tag, {"xsi:type" => "NegativeAdGroupCriterion"}) { |t| _xml(t) }
      else
        _xml(t)
      end
    end

    def to_xml(tag = nil)
      xml(Builder::XmlMarkup.new, tag)
    end

  end

end
