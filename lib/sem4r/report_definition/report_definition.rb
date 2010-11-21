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

    g_accessor :name
    g_accessor :type, { :values_in => :ReportTypes }
    g_accessor :date_range, { :values_in => :DateRangeTypes }
    g_accessor :format,  { :values_in => :DownloadFormatTypes }

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
      "'#{@name}'"
    end

    def to_xml(tag)
      #      builder = Builder::XmlMarkup.new
      #      builder.tag!(tag) do |t|
      #        t.reportName     @name
      #        t.reportType     @type
      #        t.dateRangeType  @date_range
      #        t.downloadFormat @format
      #      end

      <<EOS
        <operand>
          <reportName>Keywords performance report #1290277225130</reportName>
          <reportType>KEYWORDS_PERFORMANCE_REPORT</reportType>
          <dateRangeType>CUSTOM_DATE</dateRangeType>
          <downloadFormat>XML</downloadFormat>
          <selector>
            <fields>AdGroupId</fields>
            <fields>Id</fields>
            <fields>KeywordText</fields>
            <fields>KeywordMatchType</fields>
            <fields>Impressions</fields>
            <fields>Clicks</fields>
            <fields>Cost</fields>
            <predicates>
              <field>AdGroupId</field>
              <operator>EQUALS</operator>
              <values>0</values>
            </predicates>
            <dateRange>
              <min>20100101</min>
              <max>20100110</max>
            </dateRange>
          </selector>
        </operand>
EOS
    end


    ###########################################################################

    def self.from_element(account, el)
      new(account) do
        @id          = el.elements["id"].text.strip.to_i
        name           el.elements["name"].text.strip
        status         el.elements['status'].text.strip # ACTIVE, PAUSED, DELETED
        serving_status el.elements['servingStatus']
        start_date     el.elements['startDate']
        end_date       el.elements['endDate']
      end
    end

    def self.create(account, &block)
      new(account, &block).save
    end

    def save
      unless @id
        op = ReportDefinitionOperation.new
        op.add(self)
        # puts op.to_xml "operations"

        xml=<<EOS
<?xml version="1.0" encoding="utf-8" ?>
<env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
  <env:Header>
        <n1:RequestHeader env:mustUnderstand="0"
            xmlns:n1="https://adwords.google.com/api/adwords/cm/v201008">
          <n1:authToken>{authentication_token}</n1:authToken>
          <n1:userAgent>{useragent}</n1:userAgent>
          <n1:developerToken>{developer_token}</n1:developerToken>
          <n1:applicationToken>IGNORED</n1:applicationToken>
          <n1:clientEmail>client_1+sem4ruby@gmail.com</n1:clientEmail>
        </n1:RequestHeader>
  </env:Header>
  <env:Body>
    <n2:mutate xmlns:n2="https://adwords.google.com/api/adwords/cm/v201008">
      <n2:operations xsi:type="n2:ReportDefinitionOperation">
        <n2:operator>ADD</n2:operator>
        <n2:operand>
          <n2:selector>
            <n2:fields>AdGroupId</n2:fields>
            <n2:fields>Id</n2:fields>
            <n2:fields>KeywordText</n2:fields>
            <n2:fields>KeywordMatchType</n2:fields>
            <n2:fields>Impressions</n2:fields>
            <n2:fields>Clicks</n2:fields>
            <n2:fields>Cost</n2:fields>
            <n2:predicates>
              <n2:field>AdGroupId</n2:field>
              <n2:operator>EQUALS</n2:operator>
              <n2:values>1</n2:values>
            </n2:predicates>
            <n2:dateRange>
              <n2:min>20100101</n2:min>
              <n2:max>20100110</n2:max>
            </n2:dateRange>
          </n2:selector>
          <n2:reportName>Keywords performance report #1290336379254</n2:reportName>
          <n2:reportType>KEYWORDS_PERFORMANCE_REPORT</n2:reportType>
          <n2:dateRangeType>CUSTOM_DATE</n2:dateRangeType>
          <n2:downloadFormat>XML</n2:downloadFormat>
        </n2:operand>
      </n2:operations>
    </n2:mutate>
  </env:Body>
</env:Envelope>
EOS

        soap_message = service.report_definition.mutate_raw(credentials, xml)
                
        #soap_message = service.report_definition.mutate(credentials, op.to_xml("operations"))
        add_counters( soap_message.counters )
        rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
        id = REXML::XPath.match( rval, "id" ).first
        @id = id.text.strip.to_i
      end
      self
    end

    def delete
      soap_message = service.campaign.delete(credentials, @id)
      add_counters( soap_message.counters )
      @id = -1 # logical delete
    end

    ###########################################################################

    def empty?
      _ad_groups.empty?
    end

  end
end
