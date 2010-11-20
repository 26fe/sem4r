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

  module SoapDumper

    def initialize
      @soap_dump = false
      @soap_dump_log = nil
    end

    def dump_soap_options( dump_options )
      @soap_dump = true
      @soap_dump_log = nil

      if dump_options[:directory]
        @soap_dump_dir = dump_options[:directory]
      else
        @soap_dump_log = File.open( dump_options[:file], "w" )
      end
      @soap_dump_format = false || dump_options[:format]

      @soap_dump_interceptor = dump_options[:interceptor] if dump_options[:interceptor]
    end

    def dump_soap_request(service_url, request_xml)
      return unless @soap_dump
      %w{email password developerToken authToken clientEmail}.each do |tag|
        request_xml = request_xml.gsub(/<#{tag}([^>]*)>.*<\/#{tag}>/, "<#{tag}\\1>***censured***</#{tag}>")
      end
      str =""
      str << "<!-- Post to '#{service_url}' -->\n"
      str << xml_to_s(request_xml) << "\n"
      dump(service_url, "req", str)
    end

    def dump_soap_response(service_url, response_xml)
      return unless @soap_dump
      response_xml.gsub(/<email[^>]*>.+<\/email>/, "<email>**censured**</email>")
      str = ""
      str <<  "<!-- response -->\n"
      str << xml_to_s(response_xml) << "\n"
      str <<  "<!-- end -->"
      dump(service_url, "res", str)
    end

    private

    def dump(service_url, type, str)

      @soap_dump_interceptor.call(service_url, type, str) if @soap_dump_interceptor

      if @soap_dump_dir
        service = service_url.match(/\/([^\/]*)$/)[1]
        filename = Time.now.strftime "%Y%m%d-%H%M%S-%L-#{service}-#{type}.xml"

        FileUtils.mkdir_p(@soap_dump_dir) unless File.directory?(@soap_dump_dir)
        pathname = File.join(@soap_dump_dir, filename)
        File.open(pathname, "w") {|f|
          f.puts str
        }
      else
        @soap_dump_log.puts str
        @soap_dump_log.flush
      end
    end

    def xml_to_s(xml)
      if !@soap_dump_format
        xml
      else
        xml_document = REXML::Document.new(xml)
        f = REXML::Formatters::Pretty.new
        out = String.new
        f.write(xml_document, out)
        # remove xml directive
        out.gsub("<?xml version='1.0' encoding='UTF-8'?>","")
      end
    end
  end
end
