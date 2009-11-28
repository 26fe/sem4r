# -------------------------------------------------------------------
# Copyright (c) 2009 Sem4r sem4ruby@gmail.com
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

require File.dirname(__FILE__) + "/example_helper"
puts "---------------------------------------------------------------------"
puts "Running #{File.basename(__FILE__)}"
puts "---------------------------------------------------------------------"

begin

  #
  # config stuff
  #

  #  config = {
  #    :email           => "",
  #    :password        => "",
  #    :developer_token => ""
  #  }
  # adwords = Adwords.sandbox(config)

  adwords = Adwords.sandbox             # search credentials into ~/.sem4r file

  adwords.dump_soap_to( example_soap_log(__FILE__) )
  adwords.logger = Logger.new(STDOUT)
  # adwords.logger =  example_logger(__FILE__)

  #
  # example body
  #

  account = adwords.account
  account.p_reports

  report = account.report do
    name                 "Test Report"
    type                 "Structure"
    start_day            "2009-01-01"
    end_day              "2009-01-31"
    aggregation          "Keyword"
    column               "Campaign"
    column               "AdGroup"
    column               "Keyword"
    column               "KeywordTypeDisplay"
  end

  report.validate
  job = report.schedule
  job.wait(5) { |report, status| puts "status #{status}" }
  report.download(tmp_dirname + "/test_report.xml")

  account.p_reports(true)
  report = account.reports.first
  puts report.status(true)

  adwords.p_counters

rescue Sem4rError
  puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
end
puts "---------------------------------------------------------------------"
