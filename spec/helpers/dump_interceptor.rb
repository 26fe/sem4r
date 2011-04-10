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

class DumpInterceptor
  include Sem4rSpecHelper

  def reset_and_start
    @request_number = 0
    @where_to_write = []
    @state          = :started
  end

  def reset_and_stop
    @request_number = 0
    @where_to_write = []
    @state          = :stopped
  end

  def start
    @state = :started
  end

  def stop
    @state = :stopped
  end

  def intercept_to(p1, p2 = nil)
    if p2
      service = p1
      file    = p2
    else
      service = nil
      file    = p1
    end

    @where_to_write << [service, file]  # for req
    @where_to_write << [service, file]  # for res
  end

  def call(service_url, type, xml)
    return if @state == :stopped

    match_data = service_url.match(/https:\/\/adwords-sandbox.google.com\/api\/adwords\/([^\/]*)\/(v201008|v201101)\/(?<soap_service>[^\/]*)$/)
    unless match_data
      puts "*********** DumpInterceptor cannot recognize service"
      puts "*********** #{service_url}"
      return
    end

    soap_service = match_data[:soap_service]
    soap_service = soap_service.gsub("Service", "").underscore

    if @where_to_write.length <= @request_number
      puts "************ DumpInterceptor I cannot know where to write soap messages!!!!"
      @request_number += 1
      return
    end

    service, file = *@where_to_write[@request_number]
    if !service.nil? and service != soap_service
      puts "************ DumpInterceptor service #{soap_service} instead of #{service}!!!!"
      @request_number += 1
      return
    end
    file += "-#{type}.xml"
    write_xml(soap_service, file, xml)
    @request_number += 1
  end

end
