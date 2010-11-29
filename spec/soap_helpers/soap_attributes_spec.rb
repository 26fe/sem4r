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

require File.expand_path(File.dirname(__FILE__) + '/../rspec_helper')

describe SoapAttributes do

  class TSoapAttributes
    include Sem4r::SoapAttributes

    enum :Types,   [:Daily, :Monthly, :Weekly, :Yearly]
    enum :Columns, [:Id, :Campaign, :Keyword]

    g_accessor :name
    g_accessor :name2,  {:xpath => "alternativeName"}
    g_accessor :type,   {:values_in => :Types}
    g_accessor :day,    {:if_type => "Daily"}
    g_accessor :month,  {:if_type => "Monthly"}
    g_accessor :myflag, {:default => false}

    g_set_accessor :column
    g_set_accessor :c_column, {:values_in => :Columns}
  end

  before do
      @t = TSoapAttributes.new
  end

  it "attributes must be definited" do
    TSoapAttributes.should have(8).attributes
    TSoapAttributes.attributes.select {|a| a.name == :name}.should have(1).attributes
    TSoapAttributes.attributes.select {|a| a.name == :columns}.should have(1).attributes
    TSoapAttributes.attributes.select {|a| a.name == :column}.should be_empty
  end

  context "g_accessor" do
    it "should define constants from enum array" do
      TSoapAttributes::Daily.should eql("Daily")
      TSoapAttributes::Types.should include("Daily")
    end

    it "without constraints" do
      @t.name = "Pippo"
      @t.name.should == "Pippo"

      @t.name "Pluto"
      @t.name.should == "Pluto"
    end

    it "with constraints on value" do
      @t.type = "Daily"
      @t.type.should == "Daily"

      lambda { @t.type "Dailyy" }.should raise_error
    end

    it "with constraint on type" do
      @t.type = "Daily"
      @t.day = "2009-10-10"
      @t.day.should == "2009-10-10"

      lambda { @t.month "November" }.should raise_error
    end

    it "with default value" do
      @t.type.should   == nil
      @t.myflag.should == false
      @t.myflag = true
      @t.myflag.should == true
    end
  end

  context "g_set_accessor" do
    it "without contraints" do
      @t.column = "Id"
      @t.column   "Campaign"
      @t.columns.should include("Id")
      @t.columns.should include("Campaign")
      @t.columns.should_not include("Pluto")

      @t.should have(2).columns
      @t.column = "Id"
      @t.should have(2).columns
    end

    it "with values constraints" do
      @t.c_column = "Id"
      @t.c_columns.should include("Id")

      lambda { @t.c_column = "Pluto" }.should raise_error
    end
  end

  it "must generate xml" do
    @t.name  = "donald"
    @t.name2 = "paperino"
    expected = "<object><name>donald</name><alternativeName>paperino</alternativeName><myflag>false</myflag></object>"
    @t._to_xml("object").should == expected
  end

  it "must read xml" do
    expected = "<object><name>donald</name><alternativeName>paperino</alternativeName><myflag>false</myflag></object>"
    d = Nokogiri::XML::Document.parse(expected)
    t = TSoapAttributes._from_element(d.at_xpath("//object"))
    t.name.should == "donald"
    t.name2.should == "paperino"
  end
end
