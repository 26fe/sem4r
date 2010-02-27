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
  class Report < Base

    enum :AggregationTypes, [ 
      :Summary,
      :Daily,     :Weekly,  :Monthly,  :Quarterly,  :Yearly,
      :DayOfWeek,
      :HourlyByDate, :HourlyRegardlessDate,
      :Campaign, :AdGroup, :Keyword,
      :Creative
      ]

    enum :Columns, [
      :Campaign,
      :AdGroup,
      :Keyword,
      :KeywordTypeDisplay]

    enum :ReportTypes, [
      :Account,           # Account Performance
      :AdGroup,           # Ad Group Performance
      :Campaign,          # Campaign Performance
      :Demographic,       # Demographic Performance
      :ContentPlacement,  # Placement Performance
      :Creative,          # Ad Performance
      :Geographic,        # Geographic Performance
      :Keyword,           # Placement / Keyword Performance
      :Query,             # Search Query Performance
      :ReachAndFrequency, # Reach and Frequency Performance
      :Structure,         # Account Structure
      :Url                # URL Performance
    ]

    enum :Statuses, [ :Pending, :InProgress, :Completed, :Failed ]

    ###########################################################################

    attr_reader :id
    attr_reader :account

    g_accessor :name

    g_accessor :start_day
    g_accessor :end_day

    def days(start_day, end_day)
      self.start_day start_day
      self.end_day end_day
    end

    g_accessor :aggregation
    g_accessor :type
    g_accessor :cross_client,    {:default => false}
    g_accessor :zero_impression, {:default => false}

    g_reader   :status

    g_set_accessor :column

    ###########################################################################

    def initialize(account, &block)
      super( account.adwords, account.credentials )
      @account = account
      instance_eval(&block) if block_given?
    end

    def to_s
      "#{id} '#{name}' #{status}"
    end

    def to_xml
      builder = Builder::XmlMarkup.new
      xml = builder.job("xsi:type" => "DefinedReportJob") do |job|
        job.name                name
        job.selectedReportType  type
        job.startDay            start_day
        job.endDay              end_day
        job.aggregationTypes    aggregation

        job.crossClient           cross_client
        job.includeZeroImpression zero_impression

        columns.each do |column|
          job.selectedColumns column
        end
      end
      xml.to_s
    end

    def self.from_element(account, el)
      new(account) do
        @id       = el.elements["id"].text.strip.to_i         # id is read only
        name        el.elements["name"].text
        start_day   el.elements["startDay"].text
        end_day     el.elements["endDay"].text
        @status   = el.elements["status"].text     # status is read only
      end
    end

    ############################################################################

    def status(refresh = false)
      return @status unless refresh
      soap_message = service.report.status(credentials, @id)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//getReportJobStatusResponse/getReportJobStatusReturn")
      @status = el.text
    end

    # Validate the report definition to make sure it is valid.
    # If it is not, an AdWords::Error::ApiError will be thrown.
    def validate
      begin
        service.report.validate(credentials, to_xml)
        return true
      rescue SoapError => e
        puts e
      end
      return false
    end

    def schedule
      soap_message = service.report.schedule(credentials, to_xml)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//scheduleReportJobResponse/scheduleReportJobReturn")
      @id = el.text
      # puts "requested report assigned job nr. #{@job_id}"
      ReportJob.new(self, @id)
    end

    def url
      soap_message = service.report.url(credentials, @id)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//getReportDownloadUrlResponse/getReportDownloadUrlReturn")
      url = el.text
      url
    end

    def download(path_name)
      service.report.download(url, path_name)
    end
    
  end
end
