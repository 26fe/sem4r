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
  class BulkMutateJob
    include SoapAttributes

    attr_reader :id
    attr_accessor :campaign_id

    g_accessor :status

    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def add_operation(operation)
      @operations ||= []
      @operations << operation
    end

    def to_xml
      xml =<<-EOS
      <request>
        <partIndex>0</partIndex>
        <operationStreams>
          <scopingEntityId>
            <type>CAMPAIGN_ID</type>
            <value>#{campaign_id}</value>
          </scopingEntityId>
      EOS

      if @operations
        @operations.each do |operation|
          xml += "<operations xsi:type=\"AdGroupAdOperation\">"
          xml += operation.to_xml
          xml += "</operations>"
        end
      end
   
      xml +=<<-EOS
        </operationStreams>
      </request>
      <numRequestParts>1</numRequestParts>
      EOS
    end

    def self.from_element(el)
      new do
        @id          = el.elements["id"].text.strip.to_i
        status         el.elements["status"].text
      end
    end

    def to_s
      "#{@id} #{status}"
    end

  end

end
