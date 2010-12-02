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

  class CliCommand #:nodoc: all

    class << self

      def inherited(base)
        @command_list ||= []
        @command_list << base
      end

      def commands
        return @commands if @commands
        @commands = {}
        @command_list.each { |cmd| @commands[cmd.command] = cmd }
        @commands
      end

      def split_args(argv)
        idx = argv.find_index { |e| commands.key?(e) }
        if idx
          common_args  = argv[0,idx]
          command      = argv[idx]
          command_args = argv[idx+1..-1]
          return [common_args, command, command_args]
        else
          return [argv, nil, nil]
        end
      end

      def define_command(command_name, description_str, &block)

        unless block_given?
          raise "define_command: missing block"
        end

        cls = Class.new(CliCommand) do
          def initialize(common_args)
            @common_args = common_args
          end

          def opt_parser(options)
            opt_parser = OptionParser.new
            opt_parser.banner= "#{self.class.description}"
            opt_parser.on("-h", "--help", "show this message") do
              puts opt_parser
              options.exit = true
            end
          end

          define_method("parse_and_run") do |argv|
            options = OpenStruct.new
            opt_parser(options).parse( argv )
            return false if options.exit
            account = @common_args.account
            unless account
              puts "select an account!"
              false
            else
              return block.call(account)
            end
          end
        end

        s = class << cls; self; end
        s.class_eval do
          define_method("command") { command_name }
          define_method("description") { description_str }
        end
        cls
      end

    end

  end

end
