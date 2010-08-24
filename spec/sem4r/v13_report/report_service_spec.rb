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

describe ReportService do
  include Sem4rSpecHelper

  before do
    @credentials = stub_credentials
  end

  it "should define 'all'" do
    response_xml = read_xml_file("services", "v13_report", "get_all_jobs-res.xml")

    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    report_service = ReportService.new(connector)
    soap_message = report_service.all( @credentials )

    els = soap_message.response.xpath("//getAllJobsReturn")
    els.should_not be_empty
    els.should have(4).elements
  end

  it "should define 'validate'" do
    response_xml = read_xml_file("services", "v13_report", "get_all_jobs-res.xml")

    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    report_service = ReportService.new(connector)
    soap_message = report_service.validate( @credentials, "xml" )

    els = soap_message.response.xpath("//getAllJobsReturn")
    els.should_not be_empty
    els.should have(4).elements
  end

  it "should define 'schedule'" do
    response_xml = read_xml_file("services", "v13_report", "get_all_jobs-res.xml")

    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    report_service = ReportService.new(connector)
    soap_message = report_service.schedule( @credentials, "xml" )

    els = soap_message.response.xpath("//getAllJobsReturn")
    els.should_not be_empty
    els.should have(4).elements
  end

  it "should define 'status'" do
    response_xml = read_xml_file("services", "v13_report", "get_all_jobs-res.xml")

    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    report_service = ReportService.new(connector)
    soap_message = report_service.status( @credentials, "job_id" )

    els = soap_message.response.xpath("//getAllJobsReturn")
    els.should_not be_empty
    els.should have(4).elements
  end

  it "should define 'url'" do
    response_xml = read_xml_file("services", "v13_report", "get_all_jobs-res.xml")

    connector = mock("connector")
    connector.should_receive(:send).and_return(response_xml)

    report_service = ReportService.new(connector)
    soap_message = report_service.url( @credentials, "job_id" )

    els = soap_message.response.xpath("//getAllJobsReturn")
    els.should_not be_empty
    els.should have(4).elements
  end

end
