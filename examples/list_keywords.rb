require File.dirname(__FILE__) + "/example_helper"

begin

  adwords = Adwords.new
  adwords.dump_soap_to( example_soap_log(__FILE__) )
  adwords.logger = Logger.new(STDOUT)
  # adwords.logger = example_logger(__FILE__)

  puts "List Adgroup Keywords"

  adwords.accounts.each do |account|
    account.client_accounts.each do |client_account|
      puts "examinate account '#{client_account.credentials.client_email}'"
      client_account.campaigns.each do |campaign|
        puts "examinate campaign '#{campaign}'"
        campaign.adgroups.each do |adgroup|
          adgroup.criterions.each do |criterion|
            row = []
            row << account.credentials.email
            row << client_account.credentials.client_email
            row << campaign.name
            row << adgroup.name
            
            row << criterion.type
            case criterion.type
            when Criterion::KEYWORD
              row << criterion.text
              row << criterion.match_type
            when Criterion::PLACEMENT
              row << criterion.url
            end
            
            puts row.join(",")
          end
        end
      end
    end
  end

  adwords.p_counters

  #rescue
  #  puts "I am so sorry! Something went wrong! (exception #{$!.to_s})"
end
