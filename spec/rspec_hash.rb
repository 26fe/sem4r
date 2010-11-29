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

module Sem4rSpecHelper
  ##
  # rSpec Hash additions.
  #
  # From
  #   * http://wincent.com/knowledge-base/Fixtures_considered_harmful%3F
  #   * Neil Rahilly

  class Hash

    ##
    # Filter keys out of a Hash.
    #
    #   { :a => 1, :b => 2, :c => 3 }.except(:a)
    #   => { :b => 2, :c => 3 }

    def except(*keys)
      self.reject { |k,v| keys.include?(k || k.to_sym) }
    end

    ##
    # Override some keys.
    #
    #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
    #   => { :a => 4, :b => 2, :c => 3 }

    def with(overrides = {})
      self.merge overrides
    end

    ##
    # Returns a Hash with only the pairs identified by +keys+.
    #
    #   { :a => 1, :b => 2, :c => 3 }.only(:a)
    #   => { :a => 1 }

    def only(*keys)
      self.reject { |k,v| !keys.include?(k || k.to_sym) }
    end

  end
end