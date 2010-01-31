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

require File.dirname(__FILE__) + '/../spec_helper'

describe Credentials do

  it "should have getter" do
    connector = SoapConnector.new
    connector.should_receive(:authentication_token).and_return("auth_token")

    credentials = Credentials.new(
      :environment => "sandbox",
      :email => "prova",
      :password => "prova",
      :developer_token => "prova")

    credentials.email.should           eql "prova"
    credentials.password.should        eql "prova"
    credentials.developer_token.should eql "prova"
    #
    # no connector
    #
    lambda { credentials.authentication_token }.should raise_error

    credentials.connector= connector
    credentials.authentication_token.should eql "auth_token"
  end
end
