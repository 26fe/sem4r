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

require File.expand_path(File.dirname(__FILE__) + '/../../rspec_helper')

describe Address do
  include Sem4rSpecHelper

  it "should accept multiple address" do
    selector = GeoLocationSelector.new
    selector.address do
      city "Pisa"
      country "IT"
    end
    selector.address do
      address "Via Nazionale, 10"
      city "Rome"
      country "IT"
    end
    selector.should have(2).addresses
  end

  it "should build xml (input for google)" do
    address      = Address.new do
      address "Via Nazionale, 10"
      city "Rome"
      country "IT"
    end
    xml_expected = read_model("//addresses", "geo_location", "get-req.xml")
    address.should xml_equivalent(xml_expected)
  end

  it "should parse xml (produced by google)" do
    model   = read_model("//address", "geo_location", "get-res.xml")
    address = Address.from_element(model)
    address.city.should == "Roma"
    address.postal_code == "00184"
  end

end
