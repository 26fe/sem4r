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

require File.expand_path(File.dirname(__FILE__) + '/../rspec_helper')

describe Operation do
  include Sem4rSpecHelper

  class MyOperand

    def _xml(t)
      t.hello
    end

    def xml(t, tag = nil)
      if tag
        t.__send__(tag, {"xsi:type"=>'MyOperand'}) { |t| _xml(t) }
      else
        _xml(t)
      end
    end

    def to_xml(tag)
      xml(Builder::XmlMarkup.new, tag)
    end
  end

  it "should marshal in xml (operation.to_xml)" do
    op = Operation.add(MyOperand.new)
    op.to_xml.should == "<operations><operator>ADD</operator><operand xsi:type=\"MyOperand\"><hello/></operand></operations>"
  end

  it "should marshal in xml by builder (operation.xml)" do
    op      = Operation.add(MyOperand.new)
    builder = Builder::XmlMarkup.new
    xml     = builder.tag!("top") { |t| op.xml(t) }
    xml.should == "<top><operator>ADD</operator><operand xsi:type=\"MyOperand\"><hello/></operand></top>"
  end

  it "should add attributes to the top tag" do
    op = Operation.add(MyOperand.new)
    op.instance_eval { @attrs = {"a" => "b"} }
    op.to_xml.should == "<operations a=\"b\"><operator>ADD</operator><operand xsi:type=\"MyOperand\"><hello/></operand></operations>"
  end

  it "should add attribute type to the top tag" do
    op = Operation.add(MyOperand.new)
    op.instance_eval { @operation_type = "foo" }
    op.to_xml.should == "<operations xsi:type=\"foo\"><operator>ADD</operator><operand xsi:type=\"MyOperand\"><hello/></operand></operations>"
  end
end
