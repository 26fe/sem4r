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

  module AccountCampaignExtension
    ############################################################################
    # Campaign - Service Campaign

    # TODO: accettare un parametro opzionale campaign(name=nil,&block)
    #       la campagna che verra' creata ha il nome gia' settato
    #       se esiste gia' una campagna con quel nome allora fara' da contesto
    #       e non verra' creata
    def campaign(name = nil, &block)
      campaign = Campaign.new(self, name, &block)
      campaign.save
      @campaigns ||= []
      @campaigns.push(campaign)
      campaign
    end

    alias create_campaign campaign

    def campaigns(refresh = false, opts = {}) # conditions = nil
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end
      _campaigns unless @campaigns and !refresh
      @campaigns
      # return @campaigns unless conditions
      # @campaigns.find_all {|c| c.name =~ conditions}
    end

    def p_campaigns(refresh = false, opts = {}) # conditions = nil
      if refresh.respond_to?(:keys)
        opts = refresh
        refresh = false
      end

      cs = campaigns(refresh, opts)
      puts "#{cs.length} campaigns"
      campaigns(refresh).each do |campaign|
        puts campaign.to_s
      end
      self
    end

    private

    def _campaigns
      soap_message = service.campaign.all( credentials )
      add_counters( soap_message.counters )
      rval = soap_message.response.at_xpath("//getResponse/rval")
      els = rval.xpath("entries")
      @campaigns = els.map do |el|
        Campaign.from_element(self, el)
      end
    end
  end

  class Account
    include AccountCampaignExtension
  end

end