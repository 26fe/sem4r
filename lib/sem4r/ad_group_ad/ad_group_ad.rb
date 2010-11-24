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

module Sem4r
  class AdGroupAd < Base

    #
    # Ad.type
    #
    enum :Types, [
      :DeprecatedAd,
      :MobileAd,
      :TextAd,
      :MobileImageAd,
      :ImageAd,
      :LocalBusinessAd,
      :TemplateAd
    ]

    #
    # AdGroupAd.Status
    #
    enum :Statuses, [
      :ENABLED,
      :PAUSED,
      :DISABLED
    ]

    #
    # Ad.ApprovalStatus
    #
    enum :ApprovalStatus, [
      :APPROVED,
      :FAMILY_SAFE,
      :NON_FAMILY_SAFE,
      :PORN,
      :UNCHECKED, # Pending review
      :DISAPPROVED
    ]

    attr_reader   :ad_group
    attr_accessor :type

    # g_reader :type
    g_accessor :url
    g_accessor :display_url
    g_accessor :status, {:default => "ENABLED"}

    def initialize(ad_group, &block)
      super( ad_group.adwords, ad_group.credentials )
      @ad_group = ad_group
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def saved?
      !@id.nil?
    end
    
    # try to save when accessing id
    def id
      save unless @id
      @id
    end

    def self.from_element( ad_group, el )
      # xml_type =       el.elements["Ad.Type"].text.strip
      #=======
      xml_type =       el.at_xpath("Ad.Type").text.strip
      #>>>>>>> wordtracker/master
      case xml_type
      when TextAd
        AdGroupTextAd.from_element(ad_group, el)
      when MobileAd
        AdGroupMobileAd.from_element(ad_group, el)
      end
    end

  end
end
