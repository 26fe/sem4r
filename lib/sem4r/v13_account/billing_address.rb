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
# -------------------------------------------------------------------------

module Sem4r
  class BillingAddress
    include Sem4rSoap::SoapAttributes

    g_accessor :company_name
    g_accessor :address_line1
    g_accessor :address_line2
    g_accessor :city
    g_accessor :country_code
    g_accessor :email,           :xpath => 'emailAddress'
    g_accessor :fax_number
    g_accessor :name
    g_accessor :phone,           :xpath => 'phoneNumber'
    g_accessor :postal_code
    g_accessor :state

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.from_element(*args)
      _from_element(*args)
    end
    
    def to_s
      "#{@company_name} #{@address_line1} #{@address_line2} #{@city}"
    end

  end
end
