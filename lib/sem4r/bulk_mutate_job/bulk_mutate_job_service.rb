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
  class BulkMutateJobService
    include SoapCall

    def initialize(connector)
      @connector = connector

      @service_namespace = "https://adwords.google.com/api/adwords/cm/v201003"
      @header_namespace = @service_namespace

      @sandbox_service_url    = "https://adwords-sandbox.google.com/api/adwords/job/v201003/BulkMutateJobService"
      @production_service_url = "https://adwords.google.com/api/adwords/job/v201003/BulkMutateJobService"
    end

    soap_call_v2010 :all,    :mutate => false
    soap_call_v2010 :mutate

    private

    def _all(selector)
      "<get xmlns=\"#{@service_namespace}\">" + selector.to_xml +  '</get>';
    end

    def _mutate(job_operation)
      <<-EOFS
      <mutate xmlns="#{@service_namespace}">
        #{job_operation.to_xml('operation')}
      </mutate>
      EOFS
    end

  end
end
