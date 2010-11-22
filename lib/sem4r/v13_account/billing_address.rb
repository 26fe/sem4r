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
  class BillingAddress
    include SoapAttributes

    g_accessor :company_name
    g_accessor :address_line1
    g_accessor :address_line2
    g_accessor :city

    def initialize(&block)
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    # <billingAddress>
    #   <addressLine1>1600 Amphitheatre Parkway</addressLine1>
    #   <addressLine2>Building #42</addressLine2>
    #   <city>Mountain View</city>
    #   <companyName>Some Company</companyName>
    #   <countryCode>US</countryCode>
    #   <emailAddress>Some@email</emailAddress>
    #   <faxNumber>4085551213</faxNumber>
    #   <name>Some contact</name>
    #   <phoneNumber>4085551212</phoneNumber>
    #   <postalCode>94043</postalCode>
    #   <state>CA</state>
    # </billingAddress>
    def self.from_element(el)
      return nil unless el
      new do
        company_name          el.elements["companyName"].text.strip
        address_line1         el.elements["addressLine1"].text.strip
        address_line2         el.elements["addressLine2"].text.strip
        city                  el.elements["city"].text.strip
      end
    end

    def to_s
      "#{@company_name} #{@address_line1} #{@address_line2} #{@city}"
    end

  end
end
