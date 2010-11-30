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
# 
# -------------------------------------------------------------------------

module Sem4r

  class CliRequestReport < CliCommand #:nodoc: all

    def self.command
      "request"
    end

    def self.description
      "schedule a report"
    end

    def initialize(account)
      @account = account
    end

    def command_opt_parser(options)
      opt_parser = OptionParser.new
      opt_parser.banner = "Usage #{self.class.command} [command_options ] <report_id>"
      opt_parser.separator ""
      opt_parser.separator "#{self.class.description}"
      opt_parser.on("-h", "--help", "show this message") do
        puts opt_parser
        options.exit = true
      end
    end

    def parse_and_run(argv)
      options = OpenStruct.new
      rest = command_opt_parser(options).parse( argv )
      if options.exit
        return false
      end

      report = @account.report do
        name            'boh' 
        type            'Url'
        aggregation     'Daily'
        cross_client    true
        zero_impression true

        start_day '2010-01-01'
        end_day   '2010-01-30'

        column "CustomerName"
        column "ExternalCustomerId"
        column "CampaignStatus"
        column "Campaign"
        column "CampaignId"
        column "AdGroup"
        column "AdGroupId"
        column "AdGroupStatus"
        column "QualityScore"
        column "FirstPageCpc"
        column "Keyword"
        column "KeywordId"
        column "KeywordTypeDisplay"
        column "DestinationURL"
        column "Impressions"
        column "Clicks"
        column "CTR"
        column "CPC"
        column "MaximumCPC"
        column "Cost"
        column "AveragePosition"
      end

      unless report.validate
        puts "report not valid"
        exit
      end
      puts "scheduled job"
      job = report.schedule
      job.wait(5) { |report, status| puts "status #{status}" }
      report.download("test_report.xml")
      account.adwords.p_counters
    end

  end
end
