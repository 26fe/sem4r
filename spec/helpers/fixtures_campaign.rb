# -*- coding: utf-8 -*-
# -------------------------------------------------------------------
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
# -------------------------------------------------------------------

module FixtureCampaign

  def fixtures_campaign
    @dump_interceptor.reset_and_stop

    client_account = @adwords.account.client_accounts[1]

    puts "inspect account '#{client_account.credentials.client_email}'"
    client_account.campaigns.each do |campaign|
      puts "delete campaign '#{campaign.name}'"
      campaign.delete
    end

    intercept("mutate_add") {
      client_account.campaign "sem4r campaign #{Time.now.strftime('%m%d-%H%M%S')}" do
      end
    }
    @dump_interceptor.reset_and_stop
    intercept("get") {
      client_account.campaigns(true)
    }
  end

end
