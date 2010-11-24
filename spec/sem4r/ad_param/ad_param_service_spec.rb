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

describe AdParamService do
  include Sem4rSpecHelper

  before do
    @credentials = stub_credentials
  end

  it "should define 'all'" do
    response_xml = read_xml_file("services", "ad_param", "mutate_set-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)
    service = AdParamService.new(connector)
    soap_message = service.all( @credentials, "ad_group_id" )
    els = REXML::XPath.match( soap_message.response, "//mutateResponse")
    #=======
    #    els = soap_message.response.xpath("//mutateResponse")
    #>>>>>>> wordtracker/master
    els.should_not be_empty
  end

  it "should define 'set'" do
    @credentials.should_receive(:mutable?).and_return(true)
    response_xml = read_xml_file("services", "ad_param", "mutate_set-res.xml")
    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)
    service = AdParamService.new(connector)
    soap_message = service.mutate( @credentials, "xml" )
    els = REXML::XPath.match( soap_message.response, "//mutateResponse")
    #=======
    #    els = soap_message.response.xpath("//mutateResponse")
    #>>>>>>> wordtracker/master
    els.should_not be_empty
  end

end
