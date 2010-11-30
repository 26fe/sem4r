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

require 'rubygems'

cwd = File.expand_path( File.join( File.dirname(__FILE__), "..", "lib" ) )
$:.unshift(cwd) unless $:.include?(cwd)
require 'sem4r'
include Sem4r

def tmp_dirname
  d = File.join( File.dirname(__FILE__), "..", "tmp" )
  return d if File.directory?(d)
  
  if RUBY_PLATFORM.include?("linux")
    d = "/tmp"
    return d if File.directory?(d)
  else
    d = "c:\\temp"
    return d if File.directory?(d)
  end
  return "."
end

def example_soap_dump_options(example_file)
  return nil unless File.directory?(tmp_dirname)
  basename = File.basename(example_file).sub(/\.rb$/, '')
  log_directory =  File.join( File.join(tmp_dirname), basename)
  log_directory = File.expand_path(log_directory)
  unless File.directory?(log_directory)
    Dir.mkdir(log_directory)
  end
  puts "dump soap messages in '#{log_directory}'"
  { :directory => log_directory, :format => true }
end

def example_logger(example_file)
  return nil unless File.directory?(tmp_dirname)
  filename = File.join( tmp_dirname, File.basename(example_file).sub(/\.rb$/, ".log") )
  file = File.open( filename, "w" )
  file.sync = true
  logger = Logger.new(file)
  logger.formatter = proc { |severity, datetime, progname, msg|
    "#{datetime.strftime("%H:%M:%S")}: #{msg}\n"
  }
  logger
end


def run_example(file)
  if !block_given?
    puts "block required!"
    exit
  end
  puts "---------------------------------------------------------------------"
  puts "Running #{File.basename(file)}"
  puts "---------------------------------------------------------------------"

  begin
    #
    # config stuff
    #

    #  config = {
    #    :email           => "",
    #    :password        => "",
    #    :developer_token => ""
    #  }
    # adwords = Adwords.sandbox(config)

    adwords = Adwords.sandbox             # search credentials into ~/.sem4r file
    adwords.dump_soap_options( example_soap_dump_options(file) )
    # adwords.logger = Logger.new(STDOUT)
    adwords.logger =  example_logger(file)

    #
    # example body
    #

    yield(adwords)

    adwords.p_counters

  rescue Sem4rError
    puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
  end

  puts "---------------------------------------------------------------------"

end
