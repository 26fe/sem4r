require 'rexml/document'
require 'patron'
require 'uri'
require 'pp'
require 'logger'

require 'sem4r/credentials'
require 'sem4r/enum'

require 'sem4r/model/base'
require 'sem4r/model/account'
require 'sem4r/model/campaign'
require 'sem4r/model/adgroup'
require 'sem4r/model/adgroup_ad'
require 'sem4r/model/adgroup_bid'
require 'sem4r/model/criterion'
require 'sem4r/model/report'
require 'sem4r/model/report_job'

require 'sem4r/services/service'

module Sem4r
  class Adwords

    def initialize
      @logger = nil
    end

    ##########################################################################
    # public methods

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

    ##########################################################################
    # methods only for internal use

    attr_reader :service

    def add_counters( credentials, counters )
      counters.each_pair { |k,v|
        @counters[k] ||= 0
        @counters[k] += v
      }
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

    private

    def deferred_initialize
      @initialized = true

      @connector = SoapConnector.new
      @connector.dump_soap_to(@soap_logfile) if @soap_logfile
      @connector.logger=(@logger) if @logger

      credentials = load_credentials
      @service = Service.new(@connector)
      @accounts = credentials.map { |cred| Account.new( self, cred ) }
      @account = @accounts.first
      @counters = {
        :operations => 0,
        :response_time => 0,
        :units => 0
      }
    end

    def load_credentials(environment = :sandbox)
      yaml = YAML::load( get_config_file )
      config  = yaml['google_adwords'][environment.to_s]

      credentials = Credentials.new(
        :environment         => environment,
        :email               => config["email"],
        :password            => config["password"],
        :useragent           => "Ruby",
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
        raise "config file 'sem4r' not found "
      end
      f
    end

  end

end
