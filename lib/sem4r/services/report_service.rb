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
  class ReportService

    include SoapCall

    def initialize(connector)
      @connector = connector
      @namespace = "https://adwords.google.com/api/adwords/v13"

      @sandbox_service_url    = "https://sandbox.google.com/api/adwords/v13/ReportService"
      @production_service_url = "https://adwords.google.com/api/adwords/v13/ReportService"
    end

    soap_call_v13 :all
    soap_call_v13 :validate, :job_xml
    soap_call_v13 :schedule, :job_xml
    soap_call_v13 :status, :job_id
    soap_call_v13 :url, :job_id

    ################

    def download(url, path_name)
      @connector.download(url, path_name)
    end

    private

    def _all
      <<-EOFS
      <getAllJobs xmlns:n1="#{@namespace}">
      </getAllJobs>
      EOFS
    end

    def _validate(job_xml)
      soap_body_content = "<validateReportJob xmlns=\"#{@namespace}\">"
      soap_body_content += job_xml
      soap_body_content += "</validateReportJob>"
      soap_body_content      
    end

    def _schedule(job_xml)
      soap_body_content = "<scheduleReportJob xmlns=\"#{@namespace}\">"
      soap_body_content += job_xml
      soap_body_content += "</scheduleReportJob>"
      soap_body_content
    end

    def _status(job_id)
      <<-EOFS
        <getReportJobStatus xmlns:n1="#{@namespace}">
          <reportJobId>#{job_id}</reportJobId>
        </getReportJobStatus>
      EOFS
    end

    def _url(job_id)
      <<-EOFS
      <getReportDownloadUrl xmlns="#{@namespace}">
        <reportJobId>#{job_id}</reportJobId>
      </getReportDownloadUrl>
      EOFS
    end

  end
end
