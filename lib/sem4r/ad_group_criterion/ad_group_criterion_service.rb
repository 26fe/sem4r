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
  class AdGroupCriterionService
    include SoapCall

    def initialize(connector)
      @connector = connector
      @service_namespace = "https://adwords.google.com/api/adwords/cm/v201008"
      @header_namespace = @service_namespace

      @sandbox_service_url = "https://adwords-sandbox.google.com/api/adwords/cm/v201008/AdGroupCriterionService"
    end

    soap_call_v2010 :all,   :mutate => false
    soap_call_v2010 :mutate

    private
    
    def _all(ad_group_id)
      <<-EOFS
      <get xmlns="#{@service_namespace}">
        <selector>
          <idFilters>
            <adGroupId>#{ad_group_id}</adGroupId>
          </idFilters>
        </selector>
      </get>
      EOFS
    end

    def _mutate(xml)
      "<mutate xmlns=\"#{@service_namespace}\">#{xml}</mutate>"
    end

  end
end
