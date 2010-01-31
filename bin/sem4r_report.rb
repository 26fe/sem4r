#!/usr/bin/env ruby

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

require File.dirname(__FILE__) + "/../examples/example_helper"

class Cli

  def self.run
    cli = self.new
    if cli.parse_args( ARGV )
      cli.main
    end
  end

  def parse_args( argv )
    # stdlib
    require 'optparse'
    require 'ostruct'

    @options = OpenStruct.new :verbose => true, :force => false, :environment => 'sandbox'

    opts = OptionParser.new
    opts.banner = "Usage: sem4r_report.rb [options]"

    opts.separator ""
    opts.separator "downloads a report from adwords account using adwords api"

    #
    # common options
    #
    opts.separator ""
    opts.separator "common options: "
    opts.separator ""

    opts.on("-h", "--help", "Show this message") do
      puts opts
      return false
    end

    opts.on("--version", "Show sem4r the version") do
      puts "sem4r version #{Sem4r::version}"
      return false
    end

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      @options.verbose = v
    end

    opts.on("-q", "--quiet", "quiet mode as --no-verbose") do |v|
      @options.verbose = false
    end

    #
    # configuration file options
    #
    opts.separator ""
    opts.separator "configuration file options"
    opts.separator "if credentials options are present overwrite config option"
    opts.separator ""

    opts.on("-c", "--config CONFIG",
      "Name of the configuration to load from sem4r config file") do |config|
      @options.config_name = config
    end

    #
    # credentials options
    #
    opts.separator ""
    opts.separator "credentials options:"
    opts.separator "if credentials options are present overwrite config option"
    opts.separator ""

    environments = %w[sandbox production]
    environment_aliases = { "s" => "sandbox", "p" => "production" }
    environment_list = (environment_aliases.keys + environments).join(',')
    opts.on("-e", "--env ENVIRONMENT", environments, environment_aliases,
      "Select environment","  (#{environment_list})") do |environment|
      @options.environment = environment
    end

    opts.on("-m", "--email EMAIL",
      "Email of adwords account") do |email|
      @options.email = email
    end

    opts.on("-p", "--password PASSWORD",
      "Password of adwords account") do |password|
      @options.password = password
    end

    opts.on("-d", "--devel-token TOKEN",
      "Developer Token to access adwords api") do |token|
      @options.developer_token = token
    end

    rest = opts.parse(argv)

    # puts @options
    # p ARGV

    if rest.length != 0
      puts opts
      return false
    end
    return true
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


  def main

    puts "---------------------------------------------------------------------"
    puts "Running #{File.basename(__FILE__)}"
    puts "---------------------------------------------------------------------"

    begin
      #
      # config stuff
      #

      # search credentials into ~/.sem4r file
      if @options.config_name
        adwords = Adwords.new( @options.config_name )
      else
      end

      adwords.dump_soap_to( example_soap_log(__FILE__) )
      adwords.logger = Logger.new(STDOUT)
      # adwords.logger =  example_logger(__FILE__)

      #
      # 
      #

      account = adwords.account

      account.p_client_accounts
      
      account.p_reports
      adwords.p_counters
      

      exit
      
      report = account.report do

        name            'boh' # 'PPC Campaigns'
        type            'Url'
        aggregation     'Daily'
        cross_client    true
        zero_impression true

        start_day '2009-11-22'
        end_day   '2009-11-22'

        column "CustomerName"
        column "ExternalCustomerId"
        column "CampaignStatus"
        column "Campaign"
        column "CampaignId"
        column "AdGroup"
        column "AdGroupId"
        column "AdGroupStatus"
        column "QualityScore"
        column "FirstPageCpc"
        column "Keyword"
        column "KeywordId"
        column "KeywordTypeDisplay"
        column "DestinationURL"
        column "Impressions"
        column "Clicks"
        column "CTR"
        column "CPC"
        column "MaximumCPC"
        column "Cost"
        column "AveragePosition"
      end

      puts report.to_xml

      unless report.validate
        puts "report not valid"
        exit
      end

      job = report.schedule
      job.wait(5) { |report, status| puts "status #{status}" }
      report.download(tmp_dirname + "/test_report.xml")

      account.p_reports(true)
      adwords.p_counters

      # rescue Sem4rError
      # puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
    end
    puts "---------------------------------------------------------------------"


  end
end

Cli.run
