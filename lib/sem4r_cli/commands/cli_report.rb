# -*- coding: utf-8 -*-
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

module Sem4rCli

  class CliReport < CliCommand #:nodoc: all

    def self.command
      "report"
    end

    def self.description
      "manage report"
    end

    def initialize(common_args)
      @common_args = common_args
    end

    def command_opt_parser(options)
      opt_parser = OptionParser.new
      opt_parser.banner = "Usage #{self.class.command} [command_options ] [fields|list|create]"
      opt_parser.separator ""
      opt_parser.separator "#{self.class.description}"
      opt_parser.on("-h", "--help", "show this message") do
        puts opt_parser
        options.exit = true
      end
    end

    def parse_and_run(argv)
      options = OpenStruct.new
      rest = command_opt_parser(options).parse( argv )
      if options.exit
        return false
      end

      if rest.length != 1
        puts "missing command"
        return false
      end

      account = @common_args.account

      case rest[0]
      when "list"
        Sem4r::report(account.reports, :id, :name, :status)

      else
        puts "unknow command"
      end
      account.adwords.p_counters
      true
    end

  end
end
