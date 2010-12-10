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

module Sem4rCli

  #
  # Macro helper for define new sem4r command
  #
  def self.define_command_sem4r(command_name, description, &block)
    CliCommand.define_command(command_name, description) do |cli|
      account = cli.account
      unless account
        puts "please select a valid account!"
        false
      else
        block.call(account)
      end
    end
  end

  #
  # CliSem Driver
  #   parses common options
  #   finds command and instantiate command
  #   passes the unparsed parameter to command
  #   leaves control to command
  #
  class CliSem < Cli

    def initialize
      # defaults
      @options = OpenStruct.new({
                                    :verbose         => true,
                                    :force           => false,
                                    :default_logging => true,
                                    # :dump_soap_to_file => true,
                                    # :dump_soap_to_directory => true,
                                    :profile         => 'sandbox',
                                    :ask_password    => false
                                })
    end

    def parse_and_run(all_args)

      begin
        command_args = opt_parser(@options).order(all_args)
      rescue OptionParser::AmbiguousOption => e
        puts e.message
        return false
      end
      return true if @options.exit

      if command_args.empty?
        puts "missing command try sem -h for help"
        return false
      end

      command      = command_args[0]
      command_args = command_args[1..-1]

      # find command
      if CliCommand.commands[command].nil?
        puts "unknow command #{command}"
        return false
      end

      begin
        cmd = CliCommand.commands[command].new(self)
        return cmd.parse_and_run(command_args)
      rescue Sem4rError
        puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
        return false
      end
    end

    #
    # initialize adwords according to command line options
    # return [Sem4r::Adwords]
    #
    def adwords
      return @adwords if @adwords

      #
      # select profile
      #
      options = {}
      if @options.config_name
        options[:config_file] = @options.config_name
      end
      @adwords = Adwords.new(@options.profile, options)
      if @options.verbose
        puts "using #{@adwords.profile} profile"
        puts "config file is #{@adwords.config_file}"
      end
      #
      # Extracts dump soap options
      #
      if @options.default_logging
        configdir = File.join(ENV['HOME'], ".sem4r")
        unless File.exists?(configdir)
          puts "Directory #{configdir} not exists"
          FileUtils.mkdir(configdir)
        end
        dir                             = File.join(configdir, Time.new.strftime("%Y%m%d-soap-dump"))
        @options.dump_soap_to_directory = dir

        file                            = File.join(configdir, Time.new.strftime("%Y%m%d-sem4r-log"))
        @options.logger                 = file
      end

      if @options.dump_soap_to_file
        filename = @options.dump_soap_to_file
        o        = {:file => filename}
        @adwords.dump_soap_options(o)
      end
      if @options.dump_soap_to_directory
        dir = @options.dump_soap_to_directory
        o   = {:directory => dir, :format => true}
        @adwords.dump_soap_options(o)
      end
      if @options.verbose and adwords.dump_soap?
        puts "Logging soap conversation to '#{adwords.dump_soap_where}'"
      end
      if !@adwords.dump_soap?
        puts "it is highly recommended to activate the dump soap log"
      end

      #
      # Extracts log options
      #
      # filename = File.join( tmp_dirname, File.basename(example_file).sub(/\.rb$/, ".log") )
      if @options.logger
        # filename = "sem.log"
        @adwords.logger = @options.logger
      end
      if @adwords.logger
        puts "Logger is active" if @options.verbose
      end
      @adwords
    end

    #
    # select account according to the command line arguments
    # return [Sem4r::Account]
    #
    def account
      return @account if @account

      adwords # initialize sem4r lib adwords
      if @options.ask_password or !@adwords.has_password?
        pwd               = read_password_from_terminal
        @adwords.password = pwd
        @adwords.save_passwords
      end

      #
      # select account for command
      #
      if @options.client_email
        account = @adwords.account.client_accounts.find { |c| c.client_email =~ /#{@options.client_email}/ }
        if account.nil?
          puts "client account not found"
        else
          puts "using client #{account.client_email}"
        end
      else
        account = @adwords.account
      end
      @account = account
    end

    private

    def opt_parser(options)
      opt_parser        = OptionParser.new
      opt_parser.banner = "Sem is a simple command line interface using the sem4r library."
      opt_parser.separator "It's alpha software, please don't use in production or use it at your risk!"
      opt_parser.separator "Further information: http://www.sem4r.com"
      opt_parser.separator ""
      opt_parser.separator "Usage: sem [options] [COMMAND [command options]]"

      opt_parser.separator ""
      opt_parser.separator "execute COMMAND to an adwords account using google adwords api"
      opt_parser.separator "To view help and options for a particular command, use 'sem COMMAND -h'"

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

      opt_parser.on("--version", "show the sem4r version") do
        puts "sem4r version #{Sem4r::version}"
        options.exit = true
      end

      opt_parser.on("-v", "--[no-]verbose", "run verbosely") do |v|
        options.verbose = v
      end

      opt_parser.on("-q", "--quiet", "quiet mode as --no-verbose") do |v|
        options.verbose = false
      end

      opt_parser.on("-l", "--list-commands", "list commands") do
        puts "SEM commands are:"
        commands = CliCommand.commands.values.sort { |a, b| a.command <=> b.command }
        commands.each do |cmd|
          printf "  %-20s %s\n", cmd.command, cmd.description
        end
        puts
        puts "For help on a particular command, use 'sem COMMAND -h'"
        options.exit = true
      end

      #
      # Logging
      #
      opt_parser.separator ""
      opt_parser.separator "logging options: "
      opt_parser.separator ""

      opt_parser.on("--log FILE", "log sem4r messages to file") do |v|
        options.logger = v
      end

      opt_parser.on("--dump-file FILE", "dump soap conversation to file") do |v|
        options.dump_soap_to_file = v
      end

      str = "dump soap conversation to directory: each \n"
      str << (" " * 37) + "request/response is in a single file"
      opt_parser.on("--dump-dir DIRECTORY", str) do |v|
        options.dump_soap_to_directory = v
      end

      #
      # Profile - Configuration
      #
      opt_parser.separator ""
      opt_parser.separator "profile and credentials options: "
      opt_parser.separator "  credentials options overwrite profile attributes"
      opt_parser.separator ""

      str = "file where profiles are defined\n"
      str << (" " * 37) + "(default $HOME/.sem4r/sem4r.yaml)"
      opt_parser.on("--config CONFIG", str) do |config|
        options.config_name = config
      end

      opt_parser.on("-p", "--profile PROFILE", "select profile (default is sandbox)") do |profile|
        options.profile = profile
      end

      # email
      opt_parser.on("--email EMAIL",
                    "email of adwords account") do |email|
        options.email = email
      end

      # password
      opt_parser.on("-a", "--ask-password",
                    "ask password on terminal") do
        options.ask_password = true
      end

      opt_parser.on("--password PASSWORD",
                    "password of adwords account") do |password|
        options.password = password if password
      end

      # developer token
      opt_parser.on("--token TOKEN",
                    "developer token to access adwords api") do |token|
        options.developer_token = token
      end

      # client account
      opt_parser.on("-c", "--client EMAIL",
                    "email for client account") do |email|
        options.client_email = email
      end
      opt_parser.separator ""
      opt_parser
    end

    def read_password_from_terminal
      ask("Enter your password:  ") { |q| q.echo = "x" }
    end

  end

end # module Sem4rCli
