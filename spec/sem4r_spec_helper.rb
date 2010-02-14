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

module Sem4rSpecHelper

  def read_xml_file(*args)
    xml_filepath  = File.join(File.dirname(__FILE__), "fixtures", *args)
    unless File.exist?(xml_filepath)
      raise "file #{xml_filepath} not exists"
    end
    File.open(xml_filepath).read
  end

  def read_model(xpath, *args)
    contents = read_xml_file(*args)
    response_xml_wns = contents.gsub(/ns\d:/, "")
    xml_document = REXML::Document.new(response_xml_wns)
    if xpath
      REXML::XPath.first(xml_document, xpath)
    else
      xml_document.root.elements.to_a.first
    end
  end

  def read_xml_document(*args)
    contents = read_xml_file(*args)
    response_xml_wns = contents.gsub(/ns\d:/, "")
    REXML::Document.new(response_xml_wns)
  end

  #############################################################################

  def mock_service_account(service)
    xml_document = read_xml_document("services", "account_service", "get_account_info-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    account_service = stub("account_service", :account_info => soap_message)
    service.stub(:account).and_return(account_service)
  end

  def mock_service_info(service)
    xml_document = read_xml_document("services", "info_service", "get_unit_count-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    account_service = stub("account_service", :unit_cost => soap_message)
    service.stub(:info).and_return(account_service)
  end

  def mock_service_campaign(service)
    xml_document = read_xml_document("services", "campaign_service", "mutate_add-res.xml")
    soap_message_create = stub("soap_message", :response => xml_document, :counters => nil)

    xml_document = read_xml_document("services", "campaign_service", "get-res.xml")
    soap_message_all = stub("soap_message", :response => xml_document, :counters => nil)

    campaign_service = stub("campaign_service", :create => soap_message_create, :all => soap_message_all)
    service.stub(:campaign).and_return(campaign_service)
  end

  def mock_service_ad_group(service)
    xml_document = read_xml_document("services", "ad_group_service", "mutate_add-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    ad_group_service = stub("adgroup_service", :create => soap_message)
    service.stub(:ad_group).and_return(ad_group_service)
  end

  def mock_service_ad_group_ad(service)
    xml_document = read_xml_document("services", "ad_group_ad_service", "mutate_add-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    ad_group_ad_service = stub("ad_group_ad_service", :create => soap_message)
    service.stub(:ad_group_ad).and_return(ad_group_ad_service)
  end

  def mock_service_ad_group_criterion(service)
    xml_document = read_xml_document("services", "ad_group_criterion_service", "mutate_add_criterion_keyword-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    ad_group_criterion_service = stub("ad_group_criterion_service", :create => soap_message)
    service.stub(:ad_group_criterion).and_return(ad_group_criterion_service)
  end

  def mock_service_ad_param(service)
    # xml_document = read_xml_document("services", "ad_group_criterion_service", "mutate_add_criterion_keyword-res.xml")
    soap_message = stub("soap_message", :response => nil, :counters => nil)
    ad_param_service = stub("ad_param_service", :set => soap_message)
    service.stub(:ad_param).and_return(ad_param_service)
  end

  #############################################################################

  def mock_adwords(services)
    adwords = stub("adwords", :service => services, :add_counters => nil)
    adwords
  end

  def mock_credentials
    stub("credentials")
  end

  def mock_account(services)
    adwords = mock_adwords(services)
    credentials = mock_credentials
    campaign = stub("campaign",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    campaign
  end

  def mock_campaign(services)
    adwords = mock_adwords(services)
    credentials = mock_credentials

    campaign = stub("campaign",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    campaign
  end

  def adgroup_mock(services)
    adwords = mock_adwords(services)
    credentials = mock_credentials

    adgroup = stub("adgroup",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    adgroup
  end

  def criterion_mock(services)
    adwords = mock_adwords(services)
    credentials = mock_credentials

    criterion = stub("criterion",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    criterion
  end
end
