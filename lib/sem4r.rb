## -------------------------------------------------------------------
##
## Sem4r: Adwords Client Library
## Copyright (c) 2009 The Hive http://www.giovanniferro.net/
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.
##
## -------------------------------------------------------------------
require 'yaml'
require 'pathname'

cwd = Pathname(__FILE__).dirname
$:.unshift(cwd.to_s) unless $:.include?(cwd.to_s) || $:.include?(cwd.expand_path.to_s)

require 'rubygems'
require 'sem4r/adwords'

module Sem4r #:nodoc:
  def self.version
    cwd = Pathname(__FILE__).dirname.expand_path.to_s
    yaml = YAML.load_file(cwd + '/../VERSION.yml')
    major = (yaml['major'] || yaml[:major]).to_i
    minor = (yaml['minor'] || yaml[:minor]).to_i
    patch = (yaml['patch'] || yaml[:patch]).to_i
    "#{major}.#{minor}.#{patch}"
  end
end
