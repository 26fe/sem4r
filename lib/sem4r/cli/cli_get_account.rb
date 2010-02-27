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

module Sem4r

  class CliGetAccount < CliCommand

    def initialize(main_cli = nil)
      @main_cli = main_cli

      # defaults
      @options = OpenStruct.new ({
          :verbose => true,
          :force   => false,
          # :dump_soap_to_file => true,
          :dump_soap_to_directory => true,
          :profile => 'sandbox'
        })
    end

    def parse_and_run(argv)
      parse(argv)
    end

    def parse(argv)
      rest = opt_parser(@options).parse(argv)

      if @options.exit
        return false
      end
      return true
    end

    def opt_parser(options)
      opt_parser = OptionParser.new
      opt_parser.banner = "Usage: sem [common options] COMMAND [command options]"

      opt_parser.separator ""
      opt_parser.separator "execute COMMAND to an adwords account using adwords api"

      #
      # common options
      #
      opt_parser.separator ""
      opt_parser.separator "common options: "
      opt_parser.separator ""

      opt_parser.on("-h", "--help", "show this message") do
        puts opt_parser
        options.exit = true
      end

      opt_parser.on("--version", "show sem4r the version") do
        puts "sem4r version #{Sem4r::version}"
        options.exit = true
      end

      opt_parser.on("-l", "--list-commands", "list commands") do
        puts "SEM commands are:"
        @main_cli.commands.each_value { |cmd|  puts "#{cmd.command}\t#{cmd.description}" }
        puts
        puts "For help on a particular command, use 'sem COMMAND -h'"
        options.exit = true
      end

      opt_parser.on("-v", "--[no-]verbose", "run verbosely") do |v|
        options.verbose = v
      end

      opt_parser.on("-q", "--quiet", "quiet mode as --no-verbose") do |v|
        options.verbose = false
      end

      #
      # Logging
      #
      opt_parser.on("-f", "--dump-file FILE", "dump soap conversation to file") do |v|
        options.dump_soap_to_file = v
      end

      opt_parser.on("-d", "--dump-dir DIRECTORY", "dump soap conversation to directory") do |v|
        options.dump_soap_to_directory = v
      end

      #
      # profile file options
      #
      opt_parser.separator ""
      opt_parser.separator "configuration file options"
      opt_parser.separator "if credentials options are present overwrite config option"
      opt_parser.separator ""

      opt_parser.on("-c", "--config CONFIG",
        "Name of the configuration to load from sem4r config file") do |config|
        options.config_name = config
      end

      #
      # credentials options
      #
      opt_parser.separator ""
      opt_parser.separator "credentials options:"
      opt_parser.separator "if credentials options are present overwrite config option"
      opt_parser.separator ""

      profiles = %w[sandbox production]
      profile_aliases = { "s" => "sandbox", "p" => "production" }
      profile_list = (profile_aliases.keys + profiles).join(',')
      opt_parser.on("-p", "--profile PROFILE", profiles, profile_aliases,
        "select profile","  (#{profile_list})") do |profile|
        options.profile = profile
      end

      # email
      opt_parser.on("--email EMAIL",
        "email of adwords account") do |email|
        options.email = email
      end

      # password
      opt_parser.on("--password PASSWORD",
        "password of adwords account") do |password|
        options.password = password
      end

      # developer token
      opt_parser.on("--token TOKEN",
        "developer token to access adwords api") do |token|
        options.developer_token = token
      end

      # client account
      opt_parser.on("-c", "--client EMAIL",
        "run command into client account") do |email|
        options.client_email = email
      end
      opt_parser
    end

    def get_account
      if @options.verbose
        puts "using profile #{@options.profile}"
      end

      #
      # select profile
      #
      adwords = Adwords.new( @options.profile )

      #
      # setup logging
      #
      if @options.dump_soap_to_file
        filename = "sem-log.xml"
        #pathname = File.join( tmp_dirname, filename)
        soapdump_file = File.open( filename, "w" )
        adwords.dump_soap_options( soapdump_file )
      end

      if @options.dump_soap_to_directory
        dir = "sem-log"
        o = { :directory => dir, :format => true }
        adwords.dump_soap_options( o )
      end

      # filename = File.join( tmp_dirname, File.basename(example_file).sub(/\.rb$/, ".log") )
      filename = "sem.log"
      file = File.open( filename, "w" )
      file.sync = true
      logger = Logger.new(file)
      logger.formatter = proc { |severity, datetime, progname, msg|
        "#{datetime.strftime("%H:%M:%S")}: #{msg}\n"
      }
      adwords.logger = logger
      # adwords.logger = Logger.new(STDOUT)

      #
      # client
      #
      if @options.client_email
        account = adwords.account.client_accounts.find{ |c| c.client_email =~ /#{@options.client_account}/ }
        if account.nil?
          puts "client account not found"
        else
          puts "using client #{account.client_email}"
        end
      else
        account = adwords.account
      end
      return account
    end

    def credentials
      require "highline/import"

      unless @options.environment
        # The new and improved choose()...
        say("\nThis is the new mode (default)...")
        choose do |menu|
          menu.prompt = "Please choose your favorite programming language?  "

          menu.choice :ruby do say("Good choice!") end
          menu.choices(:python, :perl) do say("Not from around here, are you?") end
        end
      end

      @options.email           ||= ask("Enter adwords email:     ")
      @options.password        ||= ask("Enter adwords password:  ") { |q| q.echo = "x" }
      @options.developer_token ||= ask("Enter adwords developer_token:  ")

      config = {
        :environment     => @options.environment,
        :email           => @options.email,
        :password        => @options.password,
        :developer_token => @options.developer_token
      }

      pp config

      unless agree("credentials are correct?")
        exit
      end

      config
    end

  end


end
