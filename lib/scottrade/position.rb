module Scottrade
  class Position < Base
    
    attr_reader :symbol, :display_symbol, :quantity, :previous_market_close_value, :account_type, :cusip, :security_description
    attr_reader :security_class, :previous_close_price, :realTimePrice, :real_time_price, :real_time_market_value, :price_change
    
    def initialize(details)
      @symbol = details["symbol"]
      @display_symbol = details["displaySymbol"]
      @quantity = details["quantity"]
      @previous_market_close_value = Money.parse(details["prevCloseMktValue"])
      @account_type = details["accType"]
      @cusip = details["cusip"]
      @security_description = details["securityDescription"]
      @security_class = details["SecurityClass"]
      @previous_close_price = details["previousClosePrice"]
      @real_time_price = details["realTimePrice"]
      @real_time_market_value = Money.parse(details["RealTimeMktValue"])
      @price_change = Money.parse(details["priceChange"])
    end
  end
end