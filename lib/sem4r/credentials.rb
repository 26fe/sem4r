# -------------------------------------------------------------------
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
# -------------------------------------------------------------------

module Sem4r
  
  class Credentials

    attr_reader :environment
    attr_reader :email
    attr_reader :password
    attr_reader :client_email
    attr_reader :developer_token
    attr_reader :useragent

    def mutable?;    @mutable; end
    def sandbox?;    @environment != "production" end
    def production?; !sandbox?; end

    def initialize( opts, client_email = nil )
      case opts
      when Hash
        @environment=         opts[:environment].dup.freeze
        @email=               opts[:email].dup.freeze
        @password=            opts[:password].dup.freeze
        @useragent=           "Sem4r Adwords Ruby Client Library (http://github.com/sem4r/sem4r)"
        @developer_token=     opts[:developer_token].dup.freeze
        @mutable=             opts[:mutable] ? true : false
      when Credentials
        @credentials = opts
        @environment=         @credentials.environment
        @email=               @credentials.email
        @password=            @credentials.password
        @useragent=           @credentials.useragent
        @developer_token=     @credentials.developer_token
        @mutable=             @credentials.mutable?
      end

      if client_email
        @client_email = client_email.dup.freeze
      end
    end

    def to_s
      "#{@email} - #{@client_email} (#{@mutable ? "mutable" : "read only"})"
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
