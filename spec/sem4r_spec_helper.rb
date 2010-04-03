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

# comparing xml is always a b-i-a-t-c-h in any testing environment.  here is a
# little snippet for ruby that, i think, it a good first pass at making it
# easier.  comment with your improvements please!
#
# http://drawohara.com/post/89110816/ruby-comparing-xml
require 'rexml/document'
require 'differ'
require 'differ/string'

def pretty_xml(xml)
  normalized = Class.new(REXML::Formatters::Pretty) do
    def write_text(node, output)
      super(node.to_s.strip, output)
    end
  end
  normalized.new(0,false).write(xml, xml_pretty='')
  xml_pretty
end

Spec::Matchers.define :xml_equivalent do |expected_xml|
  match do |xml|
    if expected_xml.class == String
      # erase namespaces i.e. <ns1:tag> -> <tag>
      expected_xml  = expected_xml.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip
      expected_xml = REXML::Document.new(expected_xml)
    end
    expected_normalized = pretty_xml(expected_xml)
    # erase namespaces i.e. <ns1:tag> -> <tag>
    expected_normalized = expected_normalized.gsub(/(ns\d:|xsi:|s:|^\n| {2,})/, "").strip

    if xml.class == String
      xml  = xml.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip
      begin
        xml = REXML::Document.new(xml)
      rescue RuntimeError
        puts "----------------------------------"
        puts xml
        puts "----------------------------------"
        raise
      end
    end
    xml_normalized = pretty_xml(xml)
    xml_normalized = xml_normalized.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip

    if xml_normalized != expected_normalized
      puts "----differ start"

      puts xml_normalized

      puts "---"
      puts expected_normalized
      puts "---"
      diff = Differ.diff_by_line(xml_normalized, expected_normalized)
      puts diff.format_as(:ascii)
      puts "----differ end"
      false
    else
      true
    end
  end
end

Spec::Matchers.define :xml_contains do |expected_xml|
  match do |xml|
    if expected_xml.class == String
      # erase namespaces i.e. <ns1:tag> -> <tag>
      expected_xml  = expected_xml.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip
      expected_xml = REXML::Document.new(expected_xml)
    end
    expected_normalized = pretty_xml(expected_xml)
    # erase namespaces i.e. <ns1:tag> -> <tag>
    expected_normalized = expected_normalized.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip

    if xml.class == String
      xml  = xml.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip
      begin
        xml = REXML::Document.new(xml)
      rescue RuntimeError
        puts "----------------------------------"
        puts xml
        puts "----------------------------------"
        raise
      end
    end
    xml_normalized = pretty_xml(xml)
    xml_normalized = xml_normalized.gsub(/(ns\d:|xsi:|s:|^\n)/, "").strip

    unless xml_normalized.match(expected_normalized)
      false
    else
      true
    end
  end
end

module Sem4rSpecHelper

  require "stringio"
  def with_stdout_captured
    old_stdout = $stdout
    out = StringIO.new
    $stdout = out
    begin
      yield
    ensure
      $stdout = old_stdout
    end
    out.string
  end


  ##
  # rSpec Hash additions.
  #
  # From
  #   * http://wincent.com/knowledge-base/Fixtures_considered_harmful%3F
  #   * Neil Rahilly

  class Hash

    ##
    # Filter keys out of a Hash.
    #
    #   { :a => 1, :b => 2, :c => 3 }.except(:a)
    #   => { :b => 2, :c => 3 }

    def except(*keys)
      self.reject { |k,v| keys.include?(k || k.to_sym) }
    end

    ##
    # Override some keys.
    #
    #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
    #   => { :a => 4, :b => 2, :c => 3 }

    def with(overrides = {})
      self.merge overrides
    end

    ##
    # Returns a Hash with only the pairs identified by +keys+.
    #
    #   { :a => 1, :b => 2, :c => 3 }.only(:a)
    #   => { :a => 1 }

    def only(*keys)
      self.reject { |k,v| !keys.include?(k || k.to_sym) }
    end

  end


  #############################################################################

  def read_xml_file(*args)
    xml_filepath  = File.join(File.dirname(__FILE__), "fixtures", *args)
    unless File.exist?(xml_filepath)
      raise "file #{xml_filepath} not exists"
    end
    File.open(xml_filepath).read
  end

  def read_model(xpath, *args, &blk)
    contents = read_xml_file(*args)
    response_xml_wns = contents.gsub(/ns\d:/, "")
    xml_document = REXML::Document.new(response_xml_wns)
    if xpath && blk
      el = REXML::XPath.each(xml_document, xpath) do |node|
        yield node
      end
    elsif xpath
      el = REXML::XPath.first(xml_document, xpath)
    else
      el = xml_document.root.elements.to_a.first
    end
    if el.nil?
      raise "xml element not found '#{xpath}'"
    end
    el
  end

  def read_xml_document(*args)
    contents = read_xml_file(*args)
    response_xml_wns = contents.gsub(/ns\d:/, "")
    REXML::Document.new(response_xml_wns)
  end

  #############################################################################

  def stub_service_account(service)
    xml_document = read_xml_document("services", "v13_account", "get_account_info-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    account_service = stub("account_service", :account_info => soap_message)
    service.stub(:account).and_return(account_service)
  end

  def stub_service_info(service)
    xml_document = read_xml_document("services", "info", "get_unit_count-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    account_service = stub("account_service", :unit_cost => soap_message)
    service.stub(:info).and_return(account_service)
  end

  def stub_service_campaign(service)
    xml_document = read_xml_document("services", "campaign", "mutate_add-res.xml")
    soap_message_create = stub("soap_message", :response => xml_document, :counters => nil)

    xml_document = read_xml_document("services", "campaign", "get-res.xml")
    soap_message_all = stub("soap_message", :response => xml_document, :counters => nil)

    campaign_service = stub("campaign_service", :create => soap_message_create, :all => soap_message_all)
    service.stub(:campaign).and_return(campaign_service)
  end

  def stub_service_ad_group(service)
    xml_document = read_xml_document("services", "ad_group", "mutate_add-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    ad_group_service = stub("adgroup_service", :create => soap_message)
    service.stub(:ad_group).and_return(ad_group_service)
  end

  def stub_service_ad_group_ad(service)
    xml_document = read_xml_document("services", "ad_group_ad", "mutate_add_text_ad-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    ad_group_ad_service = stub("ad_group_ad_service", :create => soap_message)
    service.stub(:ad_group_ad).and_return(ad_group_ad_service)
  end

  def stub_service_ad_group_criterion(service)
    xml_document = read_xml_document("services", "ad_group_criterion", "mutate_add_criterion_keyword-res.xml")
    soap_message = stub("soap_message", :response => xml_document, :counters => nil)
    ad_group_criterion_service = stub("ad_group_criterion_service", :create => soap_message)
    service.stub(:ad_group_criterion).and_return(ad_group_criterion_service)
  end

  def stub_service_ad_param(service)
    # xml_document = read_xml_document("services", "ad_group_criterion_service", "mutate_add_criterion_keyword-res.xml")
    soap_message = stub("soap_message", :response => nil, :counters => nil)
    ad_param_service = stub("ad_param_service", :set => soap_message)
    service.stub(:ad_param).and_return(ad_param_service)
  end

  def stub_service_report(service)
    all_xml_document = read_xml_document("services", "v13_report", "get_all_jobs-res.xml")
    all_soap_message = stub("soap_message", :response => all_xml_document, :counters => nil)
    set_soap_message = stub("soap_message", :response => nil, :counters => nil)
    report_service   = stub("report_service",
      :set => set_soap_message,
      :all => all_soap_message)

    service.stub(:report).and_return(report_service)
  end

  #############################################################################

  def stub_adwords(services)
    adwords = stub("adwords", :service => services, :add_counters => nil)
    adwords
  end

  def stub_credentials
    stub("credentials",
      :sandbox?             => true,
      :email                => "example@gmail.com",
      :password             => "secret",
      :client_email         => nil,
      :useragent            => "sem4r",
      :developer_token      => "dev_token",
      :authentication_token => "1234567890"
    )
  end

  def mock_account(services)
    adwords = stub_adwords(services)
    credentials = stub_credentials
    campaign = stub("account",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    campaign
  end

  def mock_campaign(services)
    adwords = stub_adwords(services)
    credentials = stub_credentials

    campaign = stub("campaign",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    campaign
  end

  def stub_adgroup(services, id = 1000)
    adwords = stub_adwords(services)
    credentials = stub_credentials

    ad_group = stub("adgroup",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => id)
    ad_group
  end

  def stub_criterion(services)
    adwords     = stub_adwords(services)
    credentials = stub_credentials

    criterion = stub("criterion",
      :adwords     => adwords,
      :credentials => credentials,
      :id          => 1000)
    criterion
  end
end

