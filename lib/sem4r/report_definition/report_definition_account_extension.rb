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

  module ReportDefinitionAccountExtension

    #
    # Query the list of field for a report type
    # @param [ReportDefinition::ReportTypes] a value of
    #
    def report_fields(report_type)
      soap_message = service.report_definition.report_fields(credentials, report_type)
      add_counters(soap_message.counters)
      els = soap_message.response.xpath("//getReportFieldsResponse/rval")
      els.map do |el|
        ReportField.from_element(el)
      end
    end

    #
    # Delete a report definition
    #
    # @param[ReportDefinition, Number]
    #
    def report_definition_delete(repdef_or_id)
      if repdef_or_id.class == ReportDefinition
        report_definition = repdef_or_id
      else
        report_definition = ReportDefinition.new(self)
        report_definition.instance_eval { @id = repdef_or_id }
      end

      op           = ReportDefinitionOperation.remove(report_definition)
      soap_message = service.report_definition.mutate(credentials, op.to_xml)
      add_counters(soap_message.counters)

      unless @report_definitions
        @report_definition.delete_if { |repdef| repdef == report_definition.id }
      end
      report_definition.instance_eval { @id = -1 } # repdef status invalid/deleted
      self
    end

    #
    # Delete all report definition
    #
    def report_definition_delete_all
      report_definitions.each do |repdef|
        repdef.delete
      end
    end

    #
    # Create a new report definition
    # @yield report definition DSL
    # @return [ReportDefinition] in unsaved state
    #
    # @example 
    #   account.report_definition do
    #     name "MyReport"
    #     ...
    #   end
    #
    def report_definition(&block)
      ReportDefinition.new(self, &block)
    end

    #
    # Prints on stdout the list of report definition contained into account
    # @param [bool] true if the list must be refreshed
    # @return self
    #
    def p_report_definitions(refresh = false)
      report_definitions(refresh).each do |report_definition|
        puts report_definition.to_s
      end
      self
    end

    #
    # Returns an array of ReportDefinition
    # @param [bool] true if the list must be refreshed
    # @return [Array of ReportDefinition]
    #
    def report_definitions(refresh = false)
      _report_definitions unless @report_definitions and !refresh
      @report_definitions
    end

    private

    def _report_definitions
      soap_message = service.report_definition.get(credentials, ReportDefinitionSelector.new.to_xml)
      add_counters(soap_message.counters)
      els                 = soap_message.response.xpath("//entries")
      @report_definitions = els.map do |el|
        ReportDefinition.from_element(self, el)
      end
    end

  end

  class Account
    include ReportDefinitionAccountExtension
  end

end