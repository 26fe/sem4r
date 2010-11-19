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

  class ReportDefinition < Base

    attr_reader :id

    g_accessor :name

    def initialize(account, name = nil, &block)
      super( account.adwords, account.credentials )
      @account = account
      self.name = name
      if block_given?
        @inside_initialize = true
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
      @inside_initialize = false
    end

    def inside_initialize?
      @inside_initialize
    end

    def to_s
      "'#{@name}'"
    end

    def to_xml(tag)
      builder = Builder::XmlMarkup.new
      builder.tag!(tag) do |t|
        t.reportName    @name
      end
    end


    ###########################################################################

    def self.from_element(account, el)
      new(account) do
        @id          = el.elements["id"].text.strip.to_i
        name           el.elements["name"].text.strip
        status         el.elements['status'].text.strip # ACTIVE, PAUSED, DELETED
        serving_status el.elements['servingStatus']
        start_date     el.elements['startDate']
        end_date       el.elements['endDate']
      end
    end

    def self.create(account, &block)
      new(account, &block).save
    end

    def save
      unless @id
        op = ReportDefinitionOperation.new
        op.add(self)
        puts op.to_xml "operations"
        soap_message = service.report_definition.mutate(credentials, op.to_xml("operations"))
        add_counters( soap_message.counters )
        rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
        id = REXML::XPath.match( rval, "value/id" ).first
        @id = id.text.strip.to_i
      end
      self
    end

    def delete
      soap_message = service.campaign.delete(credentials, @id)
      add_counters( soap_message.counters )
      @id = -1 # logical delete
    end

    ###########################################################################

    def empty?
      _ad_groups.empty?
    end

  end
end
