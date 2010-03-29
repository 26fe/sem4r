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

describe SoapCall do
  include Sem4rSpecHelper

  def mock_connector
    mock("connector",
      :send => "")
  end

  class TSoapService
    include SoapCall

    def initialize(connector)
      @connector = connector
    end

    soap_call_v2009 :get
    soap_call_v2009 :get,    :mutate => false
    soap_call_v2009 :mutate, :mutate => true

    private

    def _get(xml)
      <<-EOFS
      <s:get>#{xml}</s:get>
      EOFS
    end
  end


  it "should define a new method" do
    t = TSoapService.new(mock_connector)
    r = t.methods.grep /^get/
    # t.methods.should include(:get)
    r.length.should == 1
  end

  it "should add a parameter to private method" do
    pending "test"
    get = TSoapService.instance_method(:get)
    _get = TSoapService.instance_method(:_get)
    get.arity.should == _get.arity + 1
  end

  it "get should call private methods _get" do
    credentials = stub_credentials
    t = TSoapService.new(mock_connector)
    t.should_receive(:_get).with("foo").and_return("")
    t.get(credentials, "foo")
  end

  it "calling mutate should raise an exception with read_only profile" do
    credentials = stub_credentials
    credentials.should_receive(:can_mutate).and_return(false)
    t = TSoapService.new(mock_connector)
    t.should_not_receive(:_mutate)
    lambda{ t.mutate(credentials, "foo")}.should raise_error(RuntimeError)
  end

  it "call mutate should call private methods _mutate with the right profile" do
    credentials = stub_credentials
    credentials.should_receive(:can_mutate).and_return(true)
    t = TSoapService.new(mock_connector)
    t.should_receive(:_mutate).with("foo").and_return("")
    t.mutate(credentials, "foo")
  end

end
