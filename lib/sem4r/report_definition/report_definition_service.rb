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

module Sem4r

  #
  # @private
  #
  class ReportDefinitionService < Sem4rSoap::SoapServiceV2010

    def initialize(connector)
      @connector        = connector
      @header_namespace = "https://adwords.google.com/api/adwords/cm/v201008"

      service_url             = "/api/adwords/cm/v201008/ReportDefinitionService"
      production_host         = "https://adwords.google.com"
      sandbox_host            = "https://adwords-sandbox.google.com"
      @production_service_url = production_host + service_url
      @sandbox_service_url    = sandbox_host + service_url

      init(@header_namespace, @service_namespace)
    end

    soap_call :get, :mutate => false
    soap_call :report_fields, :mutate => false
    soap_call :mutate

    private

    def _get(xml)
      "<get>#{xml}</get>"
    end

    def _report_fields(report_type)
      "<getReportFields><reportType>#{report_type}</reportType></getReportFields>"
    end

    def _mutate(xml)
      "<mutate>#{xml}</mutate>"
    end

  end
end
