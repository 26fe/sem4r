module Sem4r
  class ReportJob < Base

    def initialize(report, job_id)
      super( report.adwords, report.credentials )
      @job_id = job_id
    end

    def wait(&block)
      sleep_interval = 5
      status = nil
      while status != "Completed" && status != 'Failed'
        sleep(sleep_interval)
        status = status
        block.call(self, status) if block
      end
      raise "Report failed" if status == 'Failed'
    end

    def status
      soap_message = service.report.status(credentials, @job_id)
      add_counters( soap_message.counters )
      el = REXML::XPath.first( soap_message.response, "//getReportJobStatusResponse/getReportJobStatusReturn")
      status = el.text
      status
    end

  end
end
