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

# stdlib
require 'optparse'
require 'ostruct'

module Sem4r

  class CliSem

    attr_reader :commands
    
    def self.run
      cli = self.new
      cli.parse_and_run(ARGV)
    end

    def initialize
      # TODO: i comandi si dovrebbero autoregistrare!
      @commands = {}
      [CliListReport, CliListClient, CliRequestReport, CliDownloadReport, CliListKeywords, CliListAds].each do |cmd|
        @commands[cmd.command] = cmd
      end
    end

    def parse_and_run( argv )
      common_args, command, command_args = split_args(argv)

      #      $stderr.puts "debug -------------------"
      #      $stderr.puts "common_args:  #{common_args}"
      #      $stderr.puts "command:      #{command}"
      #      $stderr.puts "command_args: #{command_args}"
      #      $stderr.puts "debug -------------------"

      get_account = CliGetAccount.new(self)
      success = get_account.parse_and_run(common_args)

      return false unless success

      if command.nil?
        puts "missing command try sem -h for help"
        return false
      end

      begin
        cmd = @commands[command].new(self, get_account)
        cmd.parse_and_run(command_args)
      rescue Sem4rError
        @output.puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
      end
    end

    private


    def split_args(argv)
      idx = argv.find_index { |e| @commands.key?(e) }
      if idx
        common_args  = argv[0,idx]
        command      = argv[idx]
        command_args = argv[idx+1..-1]
        return [common_args, command, command_args]
      else
        return [argv, nil, nil]
      end
    end

  end

end
