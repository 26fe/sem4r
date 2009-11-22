require File.dirname(__FILE__) + '/../../spec_helper'

describe Credentials do

  it "should have getter" do
    connector = SoapConnector.new
    connector.should_receive(:authentication_token).and_return("auth_token")

    credentials = Credentials.new(
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
