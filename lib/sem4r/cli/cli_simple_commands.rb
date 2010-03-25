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

  class CliCommand
    def parse_and_run(argv)
    end
  end

  def self.simple_cli_command(command_name, description_str, &block)

    cls = Class.new(CliCommand) do
      def initialize(main_cli, get_account)
        @main_cli = main_cli
        @get_account = get_account
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
        account = @get_account.get_account
        block.call(account)
      end
    end

    s = class << cls; self; end
    s.class_eval do
      define_method("command") { command_name }
      define_method("description") { description_str }
    end
    cls
  end

  CliListClient = simple_cli_command("clients", "list clients account") { |account | account.p_client_accounts }
  CliListReport = simple_cli_command("reports", "list reports") { |account | account.p_reports }

end
