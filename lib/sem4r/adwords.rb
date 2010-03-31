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
      def sandbox( config = nil )
        new( "sandbox", config )
      end

      def production( config = nil )
        new( "production", config )
      end
    end

    # new( "sandbox", {:email=>"..."} )
    # new( {:environment=>"...", email => "..." } )
    # new( "sandbox" )
    # new() sandbox default
    def initialize( profile = "sandbox", options = nil )
      @logger = nil
      if not options.nil?
        # new( "sandbox", {:email=>"..."} )
        @profile = profile.to_s      
        options = options.stringify_keys
        options.assert_valid_keys("environment", "email", "password", "developer_token", "config_file")
        f = options.delete("config_file")
        self.config_file= f if f
        @options = load_config(@profile)
        @options = @options.merge(options)
      elsif profile.respond_to?(:keys)
        # new( {:environment=>"...", email => "..." } )
        @options = profile.stringify_keys
        @options.assert_valid_keys("environment", "email", "password", "developer_token")
        @profile = "anonymous_" + @options["environment"]
      else
        # new( "sandbox" )
        @profile = profile.to_s
        @options = load_config(@profile)
      end
      if ["sandbox", "production"].include?(profile)
        if @options["environment"].nil?
          @options["environment"] = profile
        end
        if @options["environment"] != profile
          raise "you cannot use profile '#{profile}' with environment #{@options["environment"]}"
        end
      end
    end

    def config_file=(file_path)
      config_filepath = File.expand_path(file_path)
      if File.exists?( config_filepath)
        @config_filepath = config_filepath
      else
        puts "#{config_filepath} not exists"
      end
      @config_filepath
    end

    # return the config file name
    def config_file
      return @config_filepath if @config_filepath
      @config_file_path = Adwords.search_config_file
      @config_file_path
    end

    def self.search_config_file
      config_filename = "sem4r.yml"

      #
      # try current directory
      #
      return File.expand_path(config_filename) if File.exists?( config_filename)

      #
      # try ~/.sem4r/sem4r.yml
      #
      # require 'etc'
      # homedir = Etc.getpwuid.dir
      homedir = ENV['HOME']
      config_filepath = File.join( homedir, ".sem4r", config_filename)
      return config_filepath if File.exists?( config_filepath )

      #
      # try <home_sem4r>/config/sem4r
      #
      config_filepath =  File.expand_path( File.join( File.dirname( __FILE__ ), "..", "..", "config", config_filename ) )
      return config_filepath if File.exists?( config_filepath )

      config_filepath =  File.expand_path( File.join( File.dirname( __FILE__ ), "..", "..", "config", "sem4r.example.yml" ) )
      return config_filepath if File.exists?( config_filepath )

      nil
    end

    def load_config(profile)
      unless config_file
        raise Sem4rError, "config file 'sem4r' not found"
      end
      puts "Loaded profiles from #{config_file}"
      yaml = YAML::load( File.open( config_file ) )
      config  = yaml['google_adwords'][profile]
      config || {}
    end

    def self.list_profiles( profile_file = nil )
      profile_file = search_config_file unless profile_file
      unless profile_file
        raise Sem4rError, "config file 'sem4r' not found"
      end
      puts "Loaded profiles from #{profile_file}"
      yaml = YAML::load( File.open( profile_file ) )
      profiles = yaml['google_adwords'].keys.map &:to_s
      profiles.sort
    end

    ##########################################################################
    # logging

    def dump_soap_options( dump_options )
      @dump_soap_options = dump_options
      @connector.dump_soap_options( dump_options ) if @connector
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
        file = File.open( logger, "a" )
        file.sync = true
        logger = Logger.new(file)
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

    def account
      deferred_initialize unless @initialized
      @account
    end

    def p_counters
      operations    = @counters[:operations]
      units         = @counters[:units]
      response_time = @counters[:response_time]
      puts "#{units} unit spent for #{operations} operations in #{response_time}ms"
    end

    ##########################################################################
    # methods only for internal use

    attr_reader :service

    #
    # TODO: credentials are necessary because you might use more then account/credentials
    #       at the same time
    #
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
      @connector.dump_soap_options(@dump_soap_options) if @dump_soap_options
      @connector.logger=(@logger) if @logger

      @credentials = Credentials.new(
        :environment         => @options["environment"],
        :email               => @options["email"],
        :password            => @options["password"],
        :useragent           => "Sem4r Adwords Ruby Client Library (http://github.com/sem4r/sem4r)",
        :developer_token     => @options["developer_token"]
      )
      @credentials.connector = @connector

      @service = Service.new(@connector)
      @account  = Account.new( self, @credentials )
      @counters = {
        :operations => 0,
        :response_time => 0,
        :units => 0
      }
    end

  end

end
