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

describe Adwords do

  before(:each) do
    @test_config_filename = File.expand_path(File.dirname(__FILE__) + "/../fixtures/sem4r.example.yml")

    @environment       = "sandbox"
    @email             = "pippo"
    @password          = "password"
    @developer_token   = "developer_token"

    @options = {
      :environment       => @environment,
      :email             => @email,
      :password          => @password,
      :developer_token   => @developer_token,
    }
  end

  it "should take an hash as configuration" do
    adwords = Adwords.new( @options )
    adwords.should_not_receive(:load_config)
    credentials = adwords.account.credentials

    adwords.profile.should               == "anonymous_" + @environment
    credentials.environment.should       == @environment
    credentials.email.should             == @email
    credentials.password.should          == @password
    credentials.developer_token.should   == @developer_token
    credentials.should_not be_mutable
  end

  it "should be mutable" do
    @options[:mutable] = true
    adwords = Adwords.new( @options )
    adwords.should_not_receive(:load_config)
    credentials = adwords.account.credentials
    credentials.should be_mutable
  end

  it "should set the right environment (sandbox)" do
    @options.delete(:environment)

    adwords = Adwords.sandbox( @options )
    credentials = adwords.account.credentials
    credentials.environment.should       == "sandbox"
    credentials.email.should             == @email
  end

  it "should set the right environment (production)" do
    @options.delete(:environment)
    adwords = Adwords.production( @options )
    credentials = adwords.account.credentials
    credentials.environment.should       == "production"
    credentials.email.should             == @email
  end
    
  it "should raise an exception when profile is sandbox and env is production" do
    @options[:environment] = "prodution"
    lambda { adwords = Adwords.sandbox( @options ) }.should raise_error(RuntimeError)

    @options[:environment] = "sandbox"
    lambda { adwords = Adwords.production( @options ) }.should raise_error(RuntimeError)
  end

  it "should read config file (profile file)" do
    adwords = Adwords.new( "sandbox", {:config_file => @test_config_filename} )
    credentials = adwords.account.credentials
    credentials.environment.should       == "sandbox"
    credentials.developer_token.should   == "example@gmail.com++EUR"

    adwords = Adwords.new( "production1", {:config_file => @test_config_filename} )
    credentials = adwords.account.credentials
    credentials.environment.should       == "production"
    credentials.developer_token.should   == "productiondevelopertoken"
  end


  it "should list profiles" do
    values = Adwords.profiles(@test_config_filename)
    #=======
    #    values = Adwords.list_profiles(@test_config_filename)
    #>>>>>>> wordtracker/master
    values.should have(4).profiles
  end

end

