## -------------------------------------------------------------------
## Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the
## "Software"), to deal in the Software without restriction, including
## without limitation the rights to use, copy, modify, merge, publish,
## distribute, sublicense, and/or sell copies of the Software, and to
## permit persons to whom the Software is furnished to do so, subject to
## the following conditions:
##
## The above copyright notice and this permission notice shall be
## included in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
## MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
## NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
## OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
## WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
## -------------------------------------------------------------------

require File.dirname(__FILE__) + "/example_helper"

# begin
  adwords = Adwords.new
  adwords.dump_soap_to( example_soap_log(__FILE__) )
  # adwords.logger = example_logger(__FILE__)
  adwords.logger = Logger.new(STDOUT)

  puts "Prune empty campaigns and adgroups"

  adwords.accounts.each do |account|
    account.client_accounts.each do |client_account|
      puts "examinate account '#{client_account.credentials.client_email}'"
      client_account.campaigns.each do |campaign|

        puts "examinate campaign '#{campaign.name}'"
        campaign.adgroups.each do |adgroup|
          if adgroup.empty?
            puts "delete adgroup '#{adgroup.name}'"
            adgroup.delete
          end
        end

        if campaign.empty?
          puts "delete campaign '#{campaign.name}'"
          campaign.delete
        end
      end
    end
  end

  adwords.p_counters

#rescue
#  puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
#end
