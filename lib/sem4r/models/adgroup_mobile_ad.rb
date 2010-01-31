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
  class AdgroupMobileAd < AdgroupAd

    enum :Markups, [
      :CHTML,
      :HTML,
      :WML,
      :XHTML
    ]

    def initialize(adgroup, &block)
      super( adgroup )
      self.type = MobileAd
      if block_given?
        instance_eval(&block)
        # save
      end
    end

    # MobileAd
    g_accessor :headline
    g_accessor :description
    g_set_accessor :markup, {:values_in => :Markups}
    g_set_accessor :carrier
    g_accessor :businessName
    g_accessor :country_code
    g_accessor :phone_number

    def image
      @image
    end

    def image(&block)
      @image = MobileAdImage.new(self, &block)
    end

  end
end
