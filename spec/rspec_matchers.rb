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
# 
# -------------------------------------------------------------------------

require 'rexml/document'
require 'differ'
require 'differ/string'

def pretty_xml(xml)
  normalized = Class.new(REXML::Formatters::Pretty) do
    def write_text(node, output)
      super(node.to_s.strip, output)
    end
  end
  normalized.new(0,false).write(xml, xml_pretty='')
  xml_pretty
end

def normalize_xml(expected_xml)
  if expected_xml.class != String
    expected_xml = expected_xml.to_s
  end

  if expected_xml.class == String
    # erase namespaces i.e. <ns1:tag> -> <tag>
    expected_xml  = expected_xml.gsub(/\b(ns\d:|xsi:|s:|soapenv:|env:|soap:|^\n)/, "").strip
    begin
      expected_xml = REXML::Document.new(expected_xml)
    rescue RuntimeError
      puts "----------------------------------"
      puts xml
      puts "----------------------------------"
      raise
    end
  end
  expected_normalized = pretty_xml(expected_xml)
  # erase namespaces i.e. <ns1:tag> -> <tag>
  expected_normalized.gsub(/(ns\d:|xsi:|s:|soapenv:|env:|soap:|^\n| {2,})/, "").strip
end

def diff_xml(expected_xml, xml)
  expected_normalized = normalize_xml(expected_xml)
  xml_normalized = normalize_xml(xml)

  if xml_normalized != expected_normalized
    puts "----differ start"

    puts xml_normalized

    puts "---"
    puts expected_normalized
    puts "---"
    diff = Differ.diff_by_line(xml_normalized, expected_normalized)
    puts diff.format_as(:ascii)
    puts "----differ end"
    false
  else
    true
  end
end

def _xml_contains(expected_xml, xml)
  expected_normalized = normalize_xml(expected_xml)
  xml_normalized = normalize_xml(xml)
  unless xml_normalized.match(expected_normalized)
    false
  else
    true
  end
end

RSpec::Matchers.define :xml_equivalent do |expected_xml|
  match do |xml|
    diff_xml(expected_xml, xml)
  end
end

RSpec::Matchers.define :xml_contains do |expected_xml|
  match do |xml|
    _xml_contains(expected_xml, xml)
  end
end
