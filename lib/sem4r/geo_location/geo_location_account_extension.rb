# -*- coding: utf-8 -*-
# -------------------------------------------------------------------------
# Copyright (c) 2009-2011 Sem4r sem4ruby@gmail.com
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

  module GeoLocationAccountExtension

    # Call geo location adwords service
    #
    # @example
    #   account.geo_location("Via Conca del Naviglio", "Milano", "IT")
    #   account.geo_location( geoLocationSelector )
    #
    def geo_location(c1, c2 = nil , c3 = nil)
      if c1.class != GeoLocationSelector
        # TODO: raise wrong number of arguments if c2 or c3 are nil
        selector = GeoLocationSelector.new
        selector.address do
          address c1
          city c2
          country c3
        end
      else
        selector = c1
      end

      soap_message = service.geo_location.get(credentials, selector.to_xml)
      add_counters(soap_message.counters)
    end
  end

  class Account
    include GeoLocationAccountExtension
  end

end
