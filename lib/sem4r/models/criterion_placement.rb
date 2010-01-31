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
  class CriterionPlacement < Criterion

    def initialize(adgroup, &block)
      super( adgroup )
      self.type = Placement
      if block_given?
        instance_eval(&block)
        save
      end
    end

    def to_s
        "#{@id} #{@type} #{@url}"
    end

    def to_xml
        str= <<-EOFS
          <criterion xsi:type="#{type}">
            <url>#{url}</url>
          </criterion>
        EOFS
      str
    end

    ###########################################################################

    g_accessor :url

    ###########################################################################
    # <entries xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="BiddableAdGroupCriterion">
    #    <adGroupId>5000010567</adGroupId>
    #    <criterion xsi:type="Keyword">
    #        <id>10008027</id>
    #        <Criterion.Type>Keyword</Criterion.Type>
    #        <text>pippo</text>
    #        <matchType>BROAD</matchType>
    #    </criterion>
    #    <AdGroupCriterion.Type>BiddableAdGroupCriterion</AdGroupCriterion.Type>
    #    <userStatus>ACTIVE</userStatus>
    #    <systemServingStatus>ELIGIBLE</systemServingStatus>
    #    <approvalStatus>PENDING_REVIEW</approvalStatus>
    #    <bids xsi:type="ManualCPCAdGroupCriterionBids">
    #        <AdGroupCriterionBids.Type>ManualCPCAdGroupCriterionBids</AdGroupCriterionBids.Type>
    #        <maxCpc>
    #            <amount>
    #                <ComparableValue.Type>Money</ComparableValue.Type>
    #                <microAmount>10000000</microAmount>
    #            </amount>
    #        </maxCpc>
    #        <bidSource>ADGROUP</bidSource>
    #    </bids>
    #    <qualityInfo>
    #        <qualityScore>5</qualityScore>
    #    </qualityInfo>
    #    <stats>
    #        <network>SEARCH</network>
    #        <Stats.Type>Stats</Stats.Type>
    #    </stats>
    #</entries>

    def self.from_element( adgroup, el )
      new(adgroup) do
        @id      = el.elements["id"].text
        url        el.elements["url"].text
      end
    end

    def self.create(adgroup, &block)
      new(adgroup, &block).save
    end

  end
end
