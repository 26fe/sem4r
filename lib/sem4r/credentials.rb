# -------------------------------------------------------------------
# Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
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
# -------------------------------------------------------------------

module Sem4r
  
  class Credentials

    attr_reader :environment
    attr_reader :email
    attr_reader :password
    attr_reader :client_email
    attr_reader :application_token
    attr_reader :developer_token
    attr_reader :useragent

    def initialize( opts, client_email = nil )
      case opts
      when Hash
        @environment=         opts[:environment]
        @email=               opts[:email]
        @password=            opts[:password]
        @useragent=           "Ruby"
        @developer_token=     opts[:developer_token]
        @application_token=   "ignored"
      when Credentials
        @credentials = opts
        @environment=         @credentials.environment
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
      @environment != :production
    end

    def production?
      !sandbox?
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
