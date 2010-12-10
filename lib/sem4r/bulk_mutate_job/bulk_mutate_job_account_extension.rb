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

  module BulkMutateJobAccountExtension

    def job_result(job_id)
      selector = BulkMutateJobSelector.new do
        jobId job_id
        stats true
        history true
      end
      soap_message = service.bulk_mutate_job.get(credentials, selector.to_xml)
      add_counters(soap_message.counters)
      self
    end

    def job_delete(job_id)
      job = BulkMutateJob.new
      job.instance_eval { @id = job_id }
      operation = JobOperation.remove(job)

      soap_message = service.bulk_mutate_job.mutate(credentials, operation.to_xml("operation"))
      add_counters(soap_message.counters)
      self
    end

    def job_mutate(bulk_mutate_job)
      soap_message = service.bulk_mutate_job.mutate(credentials, bulk_mutate_job.to_xml)
      add_counters(soap_message.counters)
      el = soap_message.response.at_xpath("//rval")
      BulkMutateJob.from_element(el)
    end

    def p_jobs
      puts "#{jobs.length} bulk mutate jobs"
      jobs.each do |job|
        puts job.to_s
      end
      self
    end

    def jobs(refresh = false)
      _jobs unless @jobs and !refresh
      @jobs
    end

    private

    def _jobs
      selector = BulkMutateJobSelector.new do
        status BulkMutateJobSelector::COMPLETED
        status BulkMutateJobSelector::PROCESSING
        status BulkMutateJobSelector::FAILED
        status BulkMutateJobSelector::PENDING
      end
      soap_message = service.bulk_mutate_job.get(credentials, selector.to_xml)
      add_counters(soap_message.counters)
      els   = soap_message.response.xpath("//getResponse/rval")
      @jobs = els.map do |el|
        BulkMutateJob.from_element(el)
      end
      @jobs
    end
  end

  class Account
    include BulkMutateJobAccountExtension
  end

end