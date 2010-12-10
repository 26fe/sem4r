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

  class ReportDefinition < Base

    attr_reader :id

    enum :ReportTypes, [
      :KEYWORDS_PERFORMANCE_REPORT,
      :AD_PERFORMANCE_REPORT,
      :URL_PERFORMANCE_REPORT,
      :ADGROUP_PERFORMANCE_REPORT,
      :CAMPAIGN_PERFORMANCE_REPORT,
      :ACCOUNT_PERFORMANCE_REPORT,
      :SEARCH_QUERY_PERFORMANCE_REPORT,
      :MANAGED_PLACEMENTS_PERFORMANCE_REPORT,
      :AUTOMATIC_PLACEMENTS_PERFORMANCE_REPORT,
      :CAMPAIGN_NEGATIVE_KEYWORDS_PERFORMANCE_REPORT,
      :CAMPAIGN_NEGATIVE_PLACEMENTS_PERFORMANCE_REPORT,
    ]

    enum :DateRangeTypes, [
      :TODAY,
      :YESTERDAY,
      :LAST_7_DAYS,
      :LAST_WEEK,
      :LAST_14_DAYS,
      :LAST_30_DAYS,
      :LAST_BUSINESS_WEEK,
      :THIS_MONTH,
      :LAST_MONTH,
      :ALL_TIME,
      :CUSTOM_DATE,
    ]

    enum :DownloadFormatTypes, [
      :CSVFOREXCEL,
      :CSV,
      :TSV,
      :XML,
      :GZIPPED_CSV,
      :GZIPPED_XML
    ]

    g_accessor :name,    { :xpath => 'reportName' }
    g_accessor :type,    { :xpath => 'reportType',     :values_in => :ReportTypes }
    g_accessor :format,  { :xpath => 'downloadFormat', :values_in => :DownloadFormatTypes }

    g_accessor :date_range, { :values_in => :DateRangeTypes }    
    g_accessor :from
    g_accessor :to
    
    g_set_accessor :field

    def initialize(account, name = nil, &block)
      super( account.adwords, account.credentials )
      @account = account
      self.name = name
      if block_given?
        @inside_initialize = true
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
      @inside_initialize = false
    end

    def inside_initialize?
      @inside_initialize
    end

    def to_s
      "#{@id}: '#{@name}'"
    end

    #
    # @private
    #
    def _xml(t)
      t.id             @id         if @id

      if !fields.empty? or ( !!from and !!to )
        #TODO: non costruire selector se il contenuto e' vuoto utile per l'operazione di delete
        t.selector do |t|
          fields.each { |f| t.fields f}

#            t.predicates do |t|
#              t.field    "AdGroupId"
#              t.operator "EQUALS"
#              t.values   1
#            end

          if from and to
            t.dateRange do |t|
              t.min from
              t.max to
            end
          end
        end
      end

      t.reportName     @name       if @name
      t.reportType     @type       if @type
      t.dateRangeType  @date_range if @date_range
      t.downloadFormat @format     if @format
    end


    #
    # Marshall to xml using a Builder::Markup
    # @param [Builder::Markup]
    #
    def xml(t, tag = nil)
      if tag
        t.__send__(tag) { |t| _xml(t) }
      else
        _xml(t)
      end
    end

    def to_xml(tag = "operand")
      xml(Builder::XmlMarkup.new, tag)
    end


    ###########################################################################

    def self.from_element(account, el)
      new(account) do

        @id          = el.at_xpath("id").text.strip.to_i
        name           el.at_xpath('reportName').text.strip
        type           el.at_xpath('reportType').text.strip
        format         el.at_xpath('downloadFormat').text.strip
        # start_date     el.at_xpath('startDate')
        # end_date       el.at_xpath('endDate')
      end
    end

    def self.create(account, &block)
      new(account, &block).save
    end

    def save
      unless @id
        op = ReportDefinitionOperation.new.add(self)
        soap_message = service.report_definition.mutate(credentials, op.to_xml("operations"))
        add_counters( soap_message.counters )
        rval = soap_message.response.at_xpath("//mutateResponse/rval")
        id = rval.at_xpath("id" )
        @id = id.text.strip.to_i
      end
      self
    end

    def delete
      @account.report_definition_delete(self)
    end

  end
end
