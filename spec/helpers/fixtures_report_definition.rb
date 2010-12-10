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

module FixtureReportDefinition

  def fixtures_report_definition
    account = @adwords.account

    @dump_interceptor.reset_and_start

    @dump_interceptor.intercept_to("report_definition", "getReportFields-{type}.xml")
    @dump_interceptor.intercept_to("report_definition", "getReportFields-{type}.xml")
    account.report_fields(ReportDefinition::KEYWORDS_PERFORMANCE_REPORT)

    @dump_interceptor.stop
    account.report_definition_delete_all


    @dump_interceptor.start
    @dump_interceptor.intercept_to("report_definition", "mutate-add-report-{type}.xml")
    @dump_interceptor.intercept_to("report_definition", "mutate-add-report-{type}.xml")

    rd = account.report_definition do
      name       "Keywords performance report #1290336379254"
      type       "KEYWORDS_PERFORMANCE_REPORT"
      date_range "LAST_WEEK"
      format     "CSV"

      field "AdGroupId"
      field "Id"
      field "KeywordText"
      field "KeywordMatchType"
      field "Impressions"
      field "Clicks"
      field "Cost"
    end
    rd.save
    puts "created report id #{rd.id}"

    @dump_interceptor.intercept_to("report_definition", "get-list-repdef-{type}.xml")
    @dump_interceptor.intercept_to("report_definition", "get-list-repdef-{type}.xml")
    account.report_definitions(true)

    @dump_interceptor.stop
  end

end