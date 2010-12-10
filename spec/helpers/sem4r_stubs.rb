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
# -------------------------------------------------------------------------

module Sem4rSpecHelper

  #############################################################################
  # stub services

  def stub_service_account(service)
    xml_document = read_xml_document("v13_account", "get_account_info-res.xml")
    soap_message_account_info = stub("soap_message_account_info", :response => xml_document, :counters => nil)

    xml_document = read_xml_document("v13_account", "get_client_accounts-res.xml")
    soap_message_client_accounts = stub("soap_message_client_accounts", :response => xml_document, :counters => nil)

    service_account = stub("service_account",
      :account_info => soap_message_account_info,
      :client_accounts => soap_message_client_accounts)
    service.stub(:account).and_return(service_account)
  end

  def stub_service_info(service)
    xml_document = read_xml_document("info", "get_unit_count-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    
    service_info = stub("service_info", :get => soap_message)
    service.stub(:info).and_return(service_info)
  end

  def stub_service_campaign(service)
    xml_document = read_xml_document("campaign", "mutate_add-res.xml")
    soap_message_create = stub("soap_message_create", :response => xml_document, :counters => nil)

    xml_document = read_xml_document("campaign", "get-res.xml")
    soap_message_all = stub("soap_message_all", :response => xml_document, :counters => nil)

    service_campaign = stub("service_campaign",
      :create => soap_message_create,
      :all => soap_message_all)
    service.stub(:campaign).and_return(service_campaign)
  end

  def stub_service_ad_group(service)
    xml_document = read_xml_document("ad_group", "mutate_add-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)

    service_ad_group = stub("service_ad_group", :create => soap_message)
    service.stub(:ad_group).and_return(service_ad_group)
  end

  def stub_service_ad_group_ad(service)
    xml_document = read_xml_document("ad_group_ad", "mutate_add_text_ad-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)

    service_ad_group_ad = stub("service_ad_group_ad", :mutate => soap_message)
    service.stub(:ad_group_ad).and_return(service_ad_group_ad)
  end

  def stub_service_ad_group_criterion(service)
    xml_document = read_xml_document("ad_group_criterion", "mutate_add_criterion_keyword-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)

    service_ad_group_criterion = stub("service_ad_group_criterion", :mutate => soap_message)
    service.stub(:ad_group_criterion).and_return(service_ad_group_criterion)
  end

  def stub_service_ad_param(service)
    # xml_document = read_xml_document("services", "ad_group_criterion_service", "mutate_add_criterion_keyword-res.xml")
    soap_message = stub("soap_message", :response => nil, :counters => nil)

    service_ad_param = stub("service_ad_param", :mutate => soap_message)
    service.stub(:ad_param).and_return(service_ad_param)
  end

  def stub_service_report(service)
    all_xml_document = read_xml_document("v13_report", "get_all_jobs-res.xml")
    all_soap_message = stub("soap_message", :response => all_xml_document, :counters => nil)
    set_soap_message = stub("soap_message", :response => nil, :counters => nil)

    service_report   = stub("service_report",
      :set => set_soap_message,
      :all => all_soap_message)

    service.stub(:report).and_return(service_report)
  end

  def stub_service_report_definition(service)
    service_report_definition   = stub("service_report_definition")
    service.stub(:report_definition).and_return(service_report_definition)
  end

  #############################################################################

  def stub_services
    double("services")
  end

  def stub_adwords(services = nil)
    stub("adwords",
      :service => services ||= stub_services,
      :add_counters => nil)
  end

  def stub_credentials
    stub("credentials",
      :sandbox?             => true,
      :email                => "example@gmail.com",
      :password             => "secret",
      :client_email         => nil,
      :useragent            => "sem4r",
      :developer_token      => "dev_token",
      :authentication_token => "1234567890",
      :mutable?             => false
    )
  end

  def stub_account(services = nil)
    adwords = stub_adwords(services)
    credentials = stub_credentials
    account = stub("account",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    account
  end

  def stub_campaign(services = nil)
    adwords = stub_adwords(services)
    credentials = stub_credentials

    campaign = stub("campaign",
      :adwords            => adwords,
      :credentials        => credentials,
      :inside_initialize? => false,
      :id                 => 1000)
    campaign
  end

  def stub_adgroup(services = nil, id = 1000)
    adwords = stub_adwords(services)
    credentials = stub_credentials
    stub("adgroup",
      :adwords            => adwords,
      :credentials        => credentials,
      :inside_initialize? => false,
      :id                 => id)
  end

  def stub_criterion(services = nil)
    adwords     = stub_adwords(services)
    credentials = stub_credentials

    stub("criterion",
      :adwords            => adwords,
      :credentials        => credentials,
      :inside_initialize? => false,
      :id                 => 1000,
      :ad_group           => stub_adgroup(services))
  end
end
