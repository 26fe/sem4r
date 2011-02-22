# -*- coding: utf-8 -*-
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
  class Adwords

    attr_reader :profile

    class << self

      #
      # Initialize Adwords with sandbox profile
      # @see Adwords#initialize
      #
      def sandbox(options = nil)
        new("sandbox", options)
      end

      #
      # Initialize Adwords with production profile
      # @see Adwords#initialize
      #
      def production(options = nil)
        new("production", options)
      end

    end

    #
    # initialize Adwords lib
    # profiles "sandbox" and "production" have blocked environment
    #
    # @param [String] profile name
    # @param [Hash] options the options for profile.
    #
    # @option opts [String] :config_file    default to "~/.sem4r/sem4r.yml"
    # @option opts [String] :password_file  default to "~/.sem4r/sem4r_password.yml"
    #
    # @option opts [String] :mutable        default to true,
    #                                       if true doesn't call mutable api call
    #
    # @option opts [String] :environment    "sandbox", "production"
    # @option opts [String] :email
    # @option opts [String] :password
    # @option opts [String] :developer_token
    #
    # @example
    #   Adwords.new( "sandbox", {:email=>"..."} )
    #   Adwords.new( {:environment=>"...", email => "..." } )
    #   Adwords.new( "sandbox" )
    #   Adwords.new() # default to sandbox
    #
    def initialize(profile = "sandbox", options = nil)
      all_keys = %w{environment email password developer_token mutable config_file password_file}
      @logger  = nil
      if not options.nil?
        # new( "profile", {:email=>"..."} )
        options  = options.stringify_keys
        options.assert_valid_keys(*all_keys)

        config_file   = options.delete("config_file")
        password_file = options.delete("password_file")
        @config = Profile.configure(config_file, password_file)

        @profile = profile.to_s
        @options = Profile.load_config(@config, @profile)
        @options = @options.merge(options)
      elsif profile.respond_to?(:keys)
        # new( {:environment=>"...", email => "..." } )
        options = profile.stringify_keys
        options.assert_valid_keys( *(all_keys-%w{config_file password_file}) )
        @config = Profile.configure
        @options = options
        @profile = "anonymous_" + @options["environment"]
      else
        # new( "sandbox" )
        @profile = profile.to_s
        @config = Profile.configure
        @options = Profile.load_config(@config, @profile)
      end
      if ["sandbox", "production"].include?(profile)
        if @options["environment"].nil?
          @options["environment"] = profile
        end
        if @options["environment"] != profile
          raise "you cannot use profile '#{profile}' with environment '#{@options["environment"]}'"
        end
      end

      Profile.try_to_find_in_password_file("password", @options, @config) unless @options["password"]
    end

    def to_s
      "adwords profile: '#{profile}' config file: '#{config_file}'"
    end

    #
    # returns profiles contained into current config file
    #
    def profiles
      Profile.profiles @config.config_file
    end

    #
    # @return [String] the config file name
    #
    def config_file
      return @config.config_file if @config
      @config = Profile.search_config
      unless @config
        puts "cannot find configuration files"
      end
      @config.config_file
    end

    ######################################################################################################
    # Password

    #
    # password is defined?
    #
    def has_password?
      !@options["password"].nil?
    end

    #
    # set password
    #
    def password=(pwd)
      if @account
        raise "already connected cannot change password"
      end
      @options["password"]=pwd
    end


    ##########################################################################
    # logging

    def dump_soap_options(dump_options)
      @dump_soap_options = dump_options
      @connector.dump_soap_options(dump_options) if @connector
    end

    def dump_soap?
      not @dump_soap_options.nil?
    end

    def dump_soap_where
      if @dump_soap_options[:directory]
        "directory:#{@dump_soap_options[:directory]}"
      else
        "file:#{@dump_soap_options[:file]}"
      end
    end

    def logger= logger
      unless logger.instance_of?(Logger)
        file             = File.open(logger, "a")
        file.sync        = true
        logger           = Logger.new(file)
        logger.formatter = proc { |severity, datetime, progname, msg|
          "#{datetime.strftime("%H:%M:%S")}: #{msg}\n"
        }
      end
      @logger= logger

      @connector.logger= logger if @connector
    end

    def logger
      @logger
    end

    ##########################################################################
    # others

    #
    # @return [Account]
    #
    def account
      deferred_initialize unless @initialized
      @account
    end

    #
    # print api counters on stdout
    #
    def p_counters
      operations    = @counters[:operations]
      units         = @counters[:units]
      response_time = @counters[:response_time]
      puts "#{units} unit spent for #{operations} operations in #{response_time}ms"
    end

    ##########################################################################
    # methods only for internal use

    attr_reader :service

    # @private
    # TODO: credentials are necessary because you might use more then account/credentials
    #       at the same time
    #
    def add_counters(credentials, counters)
      counters.each_pair { |k, v|
        @counters[k] ||= 0
        @counters[k] += v
      }
    end

    private

    # @private
    # really initialize connections to the google server
    #
    def deferred_initialize
      @initialized = true

      @connector   = Sem4rSoap::HttpConnector.get(@logger, :http_client)
      @connector.dump_soap_options(@dump_soap_options) if @dump_soap_options

      @credentials           = Credentials.new(
          :environment     => @options["environment"],
          :email           => @options["email"],
          :password        => @options["password"],
          :useragent       => "Sem4r Adwords Ruby Client Library (http://github.com/sem4r/sem4r)",
          :developer_token => @options["developer_token"],
          :mutable         => @options["mutable"]
      )
      @credentials.connector = @connector

      @service               = Service.new(@connector)
      @account               = Account.new(self, @credentials)
      @counters              = {
          :operations    => 0,
          :response_time => 0,
          :units         => 0
      }
    end

  end

end # module Sem4r
