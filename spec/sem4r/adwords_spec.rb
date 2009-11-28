# -------------------------------------------------------------------------
# Copyright (c) 2009 Sem4r sem4ruby@gmail.com
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

describe Adwords do

  before(:each) do
    @environment       = "sandbox"
    @email             = "pippo"
    @password          = "password"
    @developer_token   = "developer_token"
    @application_token = "application_token"

    @config = {
      :environment       => @environment,
      :email             => @email,
      :password          => @password,
      :developer_token   => @developer_token,
      :application_token => @application_token
    }
  end


  it "should take an hash as configuration" do
    adwords = Adwords.new( @config )
    credentials = adwords.account.credentials

    credentials.environment.should       == @environment
    credentials.email.should             == @email
    credentials.password.should          == @password
    credentials.developer_token.should   == @developer_token
    credentials.application_token.should == @application_token
  end

  it "should take the right env" do
    @config.delete(:environment)

    adwords = Adwords.sandbox( @config )
    credentials = adwords.account.credentials
    credentials.environment.should       == "sandbox"
    credentials.email.should             == @email

    adwords = Adwords.production( @config )
    credentials = adwords.account.credentials
    credentials.environment.should       == "production"
    credentials.email.should             == @email

    #    adwords = Adwords.new( "pippo", @config )
    #    credentials = adwords.account.credentials
    #    credentials.environment.should       == "aproduction"
    #    credentials.email.should             == @email
  end

  it "should read config file" do
    filename = File.dirname(__FILE__) + "/../fixtures/sem4r.example.yml"

    adwords = Adwords.new( "sandbox" )
    adwords.should_receive(:get_config_file).and_return(File.new( filename ))
    credentials = adwords.account.credentials
    credentials.environment.should       == "sandbox"
    credentials.developer_token.should   == "example@gmail.com++EUR"

    adwords = Adwords.new( "production1" )
    adwords.should_receive(:get_config_file).and_return(File.new( filename ))
    credentials = adwords.account.credentials
    credentials.environment.should       == "production"
    credentials.developer_token.should   == "productiondevelopertoken"
  end
end

