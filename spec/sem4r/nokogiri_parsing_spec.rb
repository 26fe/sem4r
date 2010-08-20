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

describe "Test Parsing with Nokogiri" do
  include Sem4rSpecHelper


  it "ddd" do
    pending "test"
    xml_document = read_xml_document("services", "ad_group_ad", "mutate_add_two_criterions-res.xml")
    els = xml_document.xpath(
        "//xmlns:mutateResponse/xmlns:rval/xmlns:value/xmlns:ad/xmlns:id", 
        xml_document.collect_namespaces)
    els.each {|e| puts e.text.strip.to_i }
  end

  it "test_account_get_client_accounts" do
    xml_document = read_xml_document("services", "v13_account", "get_client_accounts-res.xml")
    els = xml_document.xpath("//xmlns:getClientAccountsReturn", 
        xml_document.collect_namespaces)
    els.length.should == 5
  end

  it "test_campaign_get" do
    xml_document = read_xml_document("services", "campaign", "get-res.xml")
    rval =  xml_document.xpath("//xmlns:getResponse/xmlns:rval", 
        xml_document.collect_namespaces).first
    els = rval.xpath( "xmlns:entries", xml_document.collect_namespaces )

    ids_expected =
      ["53614", "53615", "53616", "54034", "54035", "55405", "55420", "56761",
      "62742", "62743", "62744", "62745", "62746", "62747", "62748"]

    names_expected = [
      "test campaign", 
      "campaign 2010-02-06 13:43:10 +0100",
      "campaign 2010-02-06 13:49:21 +0100",
      "campaign 2010-02-07 19:35:49 +0100",
      "campaign 2010-02-07 19:39:17 +0100",
      "campaign 2010-02-08 23:51:06 +0100",
      "campaign 2010-02-08 23:55:21 +0100",
      "campaign 2010-02-09 22:17:19 +0100",
      "campaign 2010-02-13 09:29:08 +0100",
      "campaign 2010-02-13 09:37:09 +0100",
      "campaign 2010-02-13 09:37:58 +0100",
      "campaign 2010-02-13 09:38:20 +0100",
      "campaign 2010-02-13 09:38:39 +0100",
      "campaign 2010-02-13 09:39:14 +0100",
      "campaign 2010-02-13 09:39:46 +0100"]

    ids   = els.map do |el| 
      el.xpath("xmlns:id", xml_document.collect_namespaces).text.strip 
    end
    
    names = els.map do |el| 
      el.xpath("xmlns:name", xml_document.collect_namespaces ).text.strip
    end

    ids_expected.should == ids
    names_expected.should == names
  end

  it "test_adgroup_criterion_get" do
    xml_document = read_xml_document("services", "ad_group_criterion", "get-res.xml")
    namespaces = xml_document.collect_namespaces
    rval = xml_document.xpath("//xmlns:getResponse/xmlns:rval", namespaces).first

    el = rval.xpath("xmlns:entries/xmlns:criterion[@xsi:type='Keyword']", 
        namespaces).first

    el.xpath("xmlns:id", namespaces).text.should == "11536082"
    el.xpath("xmlns:text", namespaces).text.should == "pippo"
    el.xpath("xmlns:matchType", namespaces).text.should == "BROAD"
  end

  it "test_info_get" do
    xml_document = read_xml_document("services", "info", "get_unit_count-res.xml")
    namespaces = xml_document.collect_namespaces

    response_header = xml_document.xpath("//ns2:ResponseHeader", namespaces).first
    response_header.xpath("xmlns:operations", namespaces).text.strip.should == "1"
    response_header.xpath("xmlns:responseTime", namespaces).text.strip.should == "173"
    response_header.xpath("xmlns:units", namespaces).text.strip.should == "1"

    cost = xml_document.xpath("//ns2:getResponse/ns2:rval/ns2:cost", 
        namespaces).first
    cost.text.strip.should == "100"
  end

end



