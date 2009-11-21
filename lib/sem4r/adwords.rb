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

require 'rexml/document'
require 'patron'
require 'uri'
require 'pp'
require 'logger'

require 'active_support/core_ext/hash.rb'

require 'sem4r/credentials'
require 'sem4r/sem4r_error'
require 'sem4r/soap_attributes'

require 'sem4r/models/base'
require 'sem4r/models/account'
require 'sem4r/models/campaign'
require 'sem4r/models/adgroup'
require 'sem4r/models/adgroup_ad'
require 'sem4r/models/criterion'
require 'sem4r/models/report'
require 'sem4r/models/report_job'

require 'sem4r/aggregates/adgroup_bid'
require 'sem4r/aggregates/billing_address'

require 'sem4r/services/service'

module Sem4r
  class Adwords

    def initialize(environment, config)
      @environment = environment
      @config = config
      @logger = nil
    end

    ##########################################################################
    # public methods

    def self.sandbox( config = nil )
      new(:sandbox, config)
    end

    def self.production( config = nil )
      new(:production, config)
    end

    def dump_soap_to( soap_logfile )
      @soap_logfile = soap_logfile
      @connector.dump_soap_to( soap_logfile ) if @connector
    end

    def logger= logger
      @logger= logger
      @connector.logger= logger if @connector
    end

    def account
      deferred_initialize unless @initialized
      @account
    end

    def accounts
      deferred_initialize unless @initialized
      @accounts
    end

    def p_counters
      #      @counters.each { |k,v|
      #        puts "#{k} => #{v}"
      #      }
      operations = @counters[:operations]
      units = @counters[:units]
      response_time = @counters[:response_time]
      puts "#{units} unit spent for #{operations} operations in #{response_time}ms"
    end

    ##########################################################################
    # methods only for internal use

    attr_reader :service

    def add_counters( credentials, counters )
      counters.each_pair { |k,v|
        @counters[k] ||= 0
        @counters[k] += v
      }
    end

    private

    def deferred_initialize
      @initialized = true

      @connector = SoapConnector.new
      @connector.dump_soap_to(@soap_logfile) if @soap_logfile
      @connector.logger=(@logger) if @logger

      credentials = load_credentials(@environment, @config)
      @service = Service.new(@connector)
      @accounts = credentials.map { |cred| Account.new( self, cred ) }
      @account = @accounts.first
      @counters = {
        :operations => 0,
        :response_time => 0,
        :units => 0
      }
    end

    def load_credentials(environment, config)

      unless config
        yaml = YAML::load( get_config_file )
        config  = yaml['google_adwords'][environment.to_s]
      end

      config.stringify_keys!
      config.assert_valid_keys("email", "password", "developer_token")

      credentials = Credentials.new(
        :environment         => environment,
        :email               => config["email"],
        :password            => config["password"],
        :useragent           => "Sem4r Adwords Ruby Client Library (http://github.com/sem4r/sem4r)",
        :developer_token     => config["developer_token"],
        :application_token   => "ignored"
      )
      credentials.connector = @connector
      [ credentials ]
    end

    def get_config_file
      config_filename = "sem4r.yml"

      # try current directory
      if File.exists?( config_filename)
        f = File.open( config_filename )
        puts "Load #{config_filepath}"
      end
      # try ~/.sem4r/sem4r.yml
      unless f
        # require 'etc'
        # homedir = Etc.getpwuid.dir
        homedir = ENV['HOME']
        config_filepath = File.join( homedir, ".sem4r", config_filename)
        if File.exists?( config_filepath )
          f = File.open( config_filepath )
          puts "Load #{config_filepath}"
        end
      end

      unless f
        config_filepath =  File.expand_path( File.join( File.dirname( __FILE__ ), "..", "..", "config", config_filename ) )
        if File.exists?( config_filepath )
          f = File.open( config_filepath )
          @logger.info("Load #{config_filepath}") if @logger
        end
      end

      unless f
        raise Sem4rError.new("config file 'sem4r' not found")
      end
      f
    end

  end

end
