module Sem4r
  
  class Credentials
  
    attr_reader :email
    attr_reader :password
    attr_reader :client_email
    attr_reader :application_token
    attr_reader :developer_token
    attr_reader :useragent

    def initialize( opts, client_email = nil )
      case opts
      when Hash
        @email=               opts[:email]
        @password=            opts[:password]
        @useragent=           "Ruby"
        @developer_token=     opts[:developer_token]
        @application_token=   "ignored"
      when Credentials
        @credentials = opts
        @email=               @credentials.email
        @password=            @credentials.password
        @useragent=           @credentials.useragent
        @developer_token=     @credentials.developer_token
        @application_token=   @credentials.application_token
      end

      if client_email
        @client_email = client_email
      end
    end

    def to_s
      "#{@email} - #{@client_email}"
    end

    def sandbox?
      true
    end

    def connector=(connector)
      @connector= connector
    end

    def authentication_token
      return @authentication_token if @authentication_token
      if @credentials
        return @authentication_token = @credentials.authentication_token
      end
      raise "no connector in credentials! use credentials.connector="  unless @connector
      @authentication_token = @connector.authentication_token(@email, @password)
      @authentication_token
    end

  end
end
