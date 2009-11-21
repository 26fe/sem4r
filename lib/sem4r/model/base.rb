module Sem4r
  class Base
    include Enum

    attr_reader :adwords
    attr_reader :credentials
    attr_reader :service

    def initialize(adwords, credentials)
      @adwords = adwords
      @credentials = credentials
      @service = adwords.service
    end

    def add_counters( counters )
      @adwords.add_counters( @credentials, counters )
    end
  
  end
end
