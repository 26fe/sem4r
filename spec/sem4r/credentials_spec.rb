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

require File.dirname(__FILE__) + '/../rspec_helper'

describe Credentials do

  before do
    @opts = {
      :environment     => "sandbox",
      :email           => "email",
      :password        => "password",
      :developer_token => "dev_token"}
  end

  it "should have getter" do
    credentials = Credentials.new(@opts)

    credentials.email.should           == "email"
    credentials.password.should        == "password"
    credentials.developer_token.should == "dev_token"
    credentials.should_not be_mutable
  end

  it "should be mutable" do
    @opts[:mutable] = true
    credentials = Credentials.new(@opts)
    credentials.should be_mutable
  end

  it "requests authentication token should raise an exception without connector" do
    credentials = Credentials.new(@opts)
    lambda { credentials.authentication_token }.should raise_error
  end
  
  it "should call connector when request for an authentication token" do
    credentials = Credentials.new(@opts)
    connector = SoapConnector.new
    connector.should_receive(:authentication_token).and_return("auth_token")
    credentials.connector= connector
    credentials.authentication_token.should == "auth_token"
  end

end
