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

require File.dirname(__FILE__) + '/../../rspec_helper'

describe "cli" do
  include Sem4rSpecHelper

  describe CliSem do
    
    it "should show help" do
      out = with_stdout_captured do
        cli = CliSem.new
        args = %w{ -h }
        cli.parse_and_run(args)
      end
      out.should match("Usage")  
    end
    
  end

  describe CliCommonArgs do

    it "should show help and exit" do
      ret = true
      out = with_stdout_captured do
        args = %w{ -h }
        cmd = CliCommonArgs.new
        ret = cmd.parse(args)
      end
      out.should match("Usage")
      ret.should be_false
    end

    it "should show version and exit" do
      ret = true
      out = with_stdout_captured do
        args = %w{ --version }
        cmd = CliCommonArgs.new
        ret = cmd.parse(args)
      end
      out.should match("sem4r version")
      ret.should be_false
    end

  end

end
