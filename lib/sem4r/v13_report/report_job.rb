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
  class ReportJob < Base

    def initialize(report, job_id)
      super( report.adwords, report.credentials )
      @job_id = job_id
    end

    def wait(sleep_interval = 10, &block)
      status = nil
      while status != "Completed" && status != 'Failed'
        sleep(sleep_interval)
        status = self.status
        block.call(self, status) if block
      end
      raise Sem4Error, "Report failed" if status == 'Failed'
    end

    def status
      soap_message = service.report.status(credentials, @job_id)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//getReportJobStatusResponse/getReportJobStatusReturn")
      #=======
      #      el = soap_message.response.xpath("//getReportJobStatusResponse/getReportJobStatusReturn").first
      #>>>>>>> wordtracker/master
      status = el.text
      status
    end

  end
end
