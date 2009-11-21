require File.dirname(__FILE__) + "/example_helper"

begin
  adwords = Adwords.new
  adwords.dump_soap_to( example_soap_log(__FILE__) )
  # adwords.logger = example_logger(__FILE__)
  adwords.logger = Logger.new(STDOUT)


  puts "List Adgroup Advertising"

  adwords.accounts.each do |account|
    account.client_accounts.each do |client_account|
      puts "examinate account '#{client_account.credentials.client_email}'"
      client_account.campaigns.each do |campaign|
        puts "examinate campaign '#{campaign}'"
        campaign.adgroups.each do |adgroup|
          puts "examinate adgroup '#{adgroup}'"
          adgroup.ads.each do |ad|
            row = []
            row << account.credentials.email
            row << client_account.credentials.client_email
            row << campaign.name
            row << adgroup.name
            row << ad.url
            row << ad.display_url
            puts row.join(",")
          end
        end
      end
    end
  end

  adwords.p_counters

# rescue
#  puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
end
