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

describe Sem4rSoap::SoapService do
  include Sem4rSpecHelper

  class TSoapService < Sem4rSoap::SoapServiceV2010

    def initialize(connector)
      @connector = connector
    end

    soap_call :get,          :mutate => false
    soap_call :get_with_arg, :mutate => false
    soap_call :mutate
    soap_call :mutate_bis,   :mutate => true

    # private

    def _get(xml)
      <<-EOFS
      <s:get>#{xml}</s:get>
      EOFS
    end

    def _get_with_arg(a1)
      "_get_with_arg"
    end
  end

  before do
    @connector = mock("connector", :send => "send")
    @readonly_credentials = stub_credentials
    @service = TSoapService.new(@connector)
  end

  it "should define a new method get" do
    @service.methods.should include(:get)    if RUBY_VERSION =~ /1\.9/
    @service.methods.should include("get")   if RUBY_VERSION =~ /1\.8/
    r = @service.methods.grep /^get$/
    r.length.should == 1
  end

  it "calling 'get' should call private method _get" do
    @service.should_receive(:_get).with("foo").and_return("get")
    soap_message = @service.get(@readonly_credentials, "foo")
  end

  it "calling 'get_with_arg' should call private method _get_with_arg" do
    @service.should_receive(:_get_with_arg).with("foo").and_return("get")
    @service.get_with_arg(@readonly_credentials, "foo")
  end

  it "calling 'mutate' should raise an exception with read_only profile" do
    @service.should_not_receive(:_mutate)
    lambda{ @service.mutate(@readonly_credentials, "foo")}.should raise_error(RuntimeError)
  end

  it "call 'mutate_bis' should raise an exception with read_only profile" do
    @service.should_not_receive(:_mutate_bis)
    lambda{ @service.mutate_bis(@readonly_credentials, "foo")}.should raise_error(RuntimeError)
  end

  it "call 'mutate' should call private methods _mutate with the right profile" do
    @mutable_credentials = stub_credentials
    @mutable_credentials.should_receive(:mutable?).and_return(true)
    @mutable_service = TSoapService.new(@connector)
    
    @mutable_service.should_receive(:_mutate).with("foo").and_return("")
    @mutable_service.mutate(@mutable_credentials, "foo")
  end

end
