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

require 'rubygems'

cwd = File.expand_path( File.join( File.dirname(__FILE__), "..", "lib" ) )
$:.unshift(cwd) unless $:.include?(cwd)
require 'sem4r'
include Sem4r

puts "---------------------------------------------------------------------"
puts "Building fixtures"
puts "---------------------------------------------------------------------"


class DumpInterceptor

  def initialize(dir)
    @dir = dir
  end

  def call(service_url, type, str)
    # puts "dump interceptor #{service_url} #{type}"

    # https://adwords-sandbox.google.com/api/adwords/info/v201008/InfoService
    match_data = service_url.match(/https:\/\/adwords-sandbox.google.com\/api\/adwords\/info\/v201008\/([^\/]*)$/)
    case match_data[1]
    when "InfoService"
      dir = File.join(@dir, "info")
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      pathname = File.join(dir, "get_unit_count-#{type}.xml")
      puts "writing to #{pathname}"
      File.open(pathname, "w") {|f|
        f.puts str
      }
    else
      puts "unknow service #{match_data[1]}"
    end

  end
end

begin
  adwords = Adwords.sandbox             # search credentials into ~/.sem4r file

  log_directory = File.join( File.dirname(__FILE__), "..", "tmp", "build_fixtures" )
  log_directory = File.expand_path(log_directory)
  Dir.mkdir(log_directory) unless File.directory?(log_directory)
  puts "dump soap messages in '#{log_directory}'"

  fixtures_dir = File.join( File.dirname(__FILE__), "fixtures", "services")
  interceptor = DumpInterceptor.new(fixtures_dir)
  dump_options = { :directory => log_directory, :format => true, :interceptor => interceptor}
  adwords.dump_soap_options( dump_options )
  adwords.logger = Logger.new(STDOUT)

  # info
  adwords.account.year_unit_cost(InfoSelector::UNIT_COUNT)

rescue Sem4rError
  puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
end

puts "---------------------------------------------------------------------"
