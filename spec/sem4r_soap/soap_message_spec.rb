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

describe Sem4rSoap::SoapMessageV13 do
  include Sem4rSpecHelper

  before do
    @credentials = stub_credentials
  end

  it "should update counters (v13 api)" do
    response_xml = read_xml("v13_report", "get_all_jobs-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    message_v13 = Sem4rSoap::SoapMessageV13.new(connector, @credentials)
    message_v13.body = ""
    message_v13.send("service_url", "soap_action")

    message_v13.counters.should_not be_empty
    message_v13.counters.should ==  { :response_time => 177, :operations => 4, :units => 4 }
  end

  it "should update counters (v13 api)" do
    response_xml = read_xml("ad_group", "get-first-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    message = Sem4rSoap::SoapMessageV2010.new(connector, @credentials)
    message.body = ""
    message.send("service_url")

    message.counters.should_not be_empty
    message.counters.should ==  { :response_time => 170, :operations => 2, :units => 2 }
  end
end
