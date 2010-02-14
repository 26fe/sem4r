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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SoapAttributes do

  class TSoapAttributes
    include Sem4r::SoapAttributes

    enum :Types,   [:Daily, :Monthly, :Weekly, :Yearly]
    enum :Columns, [:Id, :Campaign, :Keyword]

    g_accessor :name
    g_accessor :type,   {:values_in => :Types}
    g_accessor :day,    {:if_type => "Daily"}
    g_accessor :month,  {:if_type => "Monthly"}
    g_accessor :myflag, {:default => false}

    g_set_accessor :column
    g_set_accessor :c_column, {:values_in => :Columns}
  end


  describe "g_accessor" do
    it "g_accessor should define constants from enum array" do
      TSoapAttributes::Daily.should eql("Daily")
      TSoapAttributes::Types.should include("Daily")
    end

    it "g_accessor without constraints" do
      t = TSoapAttributes.new

      t.name = "Pippo"
      t.name.should == "Pippo"

      t.name "Pluto"
      t.name.should == "Pluto"
    end

    it "g_accessor with constraints on value" do
      t = TSoapAttributes.new

      t.type = "Daily"
      t.type.should == "Daily"

      lambda { t.type "Dailyy" }.should raise_error
    end

    it "g_accessor with contraint on type" do
      t = TSoapAttributes.new

      t.type = "Daily"
      t.day = "2009-10-10"
      t.day.should == "2009-10-10"

      lambda { t.month "November" }.should raise_error
    end

    it "g_accessor with default value" do
      t = TSoapAttributes.new

      t.type.should   == nil
      t.myflag.should == false
      t.myflag = true
      t.myflag.should == true
    end
  end

  describe "g_set_accessor" do
    it "g_set_accessor without contraints" do
      t = TSoapAttributes.new

      t.column = "Id"
      t.column   "Campaign"
      t.columns.should include("Id")
      t.columns.should include("Campaign")
      t.columns.should_not include("Pluto")

      t.should have(2).columns
      t.column = "Id"
      t.should have(2).columns
    end

    it "g_set_accessor with values constraints" do
      t = TSoapAttributes.new

      t.c_column = "Id"
      t.c_columns.should include("Id")

      lambda { t.c_column = "Pluto" }.should raise_error
    end
  end

end
