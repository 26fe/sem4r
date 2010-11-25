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

require File.expand_path( File.join( File.dirname(__FILE__), "example_helper") )

run_example(__FILE__) do |adwords|
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
  job.wait(5) { |r, s| puts "status #{s}" }
  report.download(tmp_dirname + "/05_request_report.xml")

  account.p_reports(true)
  report = account.reports.first
  puts report.status(true)
end
