## -------------------------------------------------------------------
## Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the
## "Software"), to deal in the Software without restriction, including
## without limitation the rights to use, copy, modify, merge, publish,
## distribute, sublicense, and/or sell copies of the Software, and to
## permit persons to whom the Software is furnished to do so, subject to
## the following conditions:
##
## The above copyright notice and this permission notice shall be
## included in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
## MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
## NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
## OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
## WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
## -------------------------------------------------------------------

require 'rubygems'

begin
  require 'sem4r'
rescue LoadError
  cwd = File.expand_path( File.join( File.dirname(__FILE__), "..", "lib" ) )
  $:.unshift(cwd) unless $:.include?(cwd)
  require 'sem4r'
end

def tmp_dirname
  File.join( File.dirname(__FILE__), "..", "tmp" )
end

def example_soap_log(example_file)
  return nil unless File.directory?(tmp_dirname)
  filename = File.join( tmp_dirname, File.basename(example_file).sub(/\.rb$/, "-log.xml") )
  File.open( filename, "w" )
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

include Sem4r
