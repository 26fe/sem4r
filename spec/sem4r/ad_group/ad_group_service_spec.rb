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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe AdGroupService do
  include Sem4rSpecHelper

  #  soap_call_v2009 :all
  #  soap_call_v2009 :create
  #  soap_call_v2009 :delete

  before(:all) do
    @credentials = mock("credentials")
    @credentials.should_receive(:sandbox?).and_return(true)

    @credentials.should_receive(:email).and_return("example@gmail.com")
    @credentials.should_receive(:password).and_return("secret")
    @credentials.should_receive(:client_email).and_return(nil)

    @credentials.should_receive(:useragent).and_return("sem4r")
    @credentials.should_receive(:developer_token).and_return("dev_token")

    @credentials.should_receive(:authentication_token).and_return("dev_token")
  end

  it "should define 'all' service" do
    @credentials.should_receive(:mutable?).and_return(false)
    response_xml = read_xml_file("services", "ad_group", "get-first-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)
    service = AdGroupService.new(connector)
    soap_message = service.all( @credentials, "campaign_id" )
    els = REXML::XPath.match( soap_message.response, "//getResponse")
    els.should_not be_empty
  end

  it "should define 'create' service" do
    pending "test"
    @credentials.should_receive(:mutable?).and_return(true)
    response_xml = read_xml_file("services", "ad_group", "mutate_add-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)
    service = AdGroupService.new(connector)
    soap_message = service.create( @credentials, "xml" )
    els = REXML::XPath.match( soap_message.response, "//mutateResponse")
    els.should_not be_empty
  end

  it "should define 'delete' service"  do
    pending "test"
    @credentials.should_receive(:mutable?).and_return(true)
    response_xml = read_xml_file("services", "ad_group", "mutate_add-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)
    service = AdGroupService.new(connector)
    soap_message = service.delete( @credentials, "id" )
    els = REXML::XPath.match( soap_message.response, "//mutateResponse")
    els.should_not be_empty
  end

end
