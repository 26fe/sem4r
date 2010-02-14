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

describe "Test Parsing with REXML" do

  include Sem4rSpecHelper

  it "test_account_get_client_accounts" do
    xml_document = read_xml_document("services", "account_service", "get_client_accounts-res.xml")
    els = REXML::XPath.match( xml_document, "//getClientAccountsReturn")
    els.length.should == 5
  end

  it "test_campaign_get" do
    xml_document = read_xml_document("services", "campaign_service", "get-res.xml")
    rval = REXML::XPath.first( xml_document, "//getResponse/rval")
    els = REXML::XPath.match( rval, "entries")

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

    ids   = els.map{|el| el.elements["id"].text.strip }
    names = els.map{|el| el.elements["name"].text.strip }

    ids_expected.should == ids
    names_expected.should == names
  end

  it "test_adgroup_criterion_get" do
    xml_document = read_xml_document("services", "ad_group_criterion_service", "get-res.xml")
    rval = REXML::XPath.first( xml_document, "//getResponse/rval")

    el = REXML::XPath.first( rval, "entries/criterion[@xsi:type='Keyword']")

    el.elements["id"].text.should == "11536082"
    el.elements["text"].text.should == "pippo"
    el.elements["matchType"].text.should == "BROAD"
  end

  it "test_info_get" do
    xml_document = read_xml_document("services", "info_service", "get_unit_count-res.xml")

    response_header = REXML::XPath.first(xml_document, "//ResponseHeader")
    response_header.elements["operations"].text.strip.should == "1"
    response_header.elements["responseTime"].text.strip.should == "173"
    response_header.elements["units"].text.strip.should == "1"

    cost = REXML::XPath.first( xml_document, "//getResponse/rval/cost")
    cost.text.strip.should == "100"
  end

end



