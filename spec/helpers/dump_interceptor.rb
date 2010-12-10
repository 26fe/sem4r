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

  def reset
    @request_number = 0
    @where_to_write = []
  end

  def intercept_to(service, file)
    @where_to_write << [service, file]
  end

  def call(service_url, type, xml)
    match_data = service_url.match(/https:\/\/adwords-sandbox.google.com\/api\/adwords\/([^\/]*)\/v201008\/([^\/]*)$/)
    unless match_data
      puts "*********** DumpInterceptor cannot recognize service"
      puts "*********** #{service_url}"
    end

    service = match_data[2]
    service = service.gsub("Service", "").underscore

    if @where_to_write.length <= @request_number
      puts "************ DumpInterceptor I cannot know where to write soap messages!!!!"
    else
      service, file = *@where_to_write[@request_number]
      file = file.gsub(/\{type\}/, type)
      write_xml(service, file, xml)
    end

    @request_number += 1
  end

end
