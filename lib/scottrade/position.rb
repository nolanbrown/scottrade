require 'money'
module Scottrade
  class Position < Base
    
    attr_reader :symbol, :displaySymbol, :quantity, :previousMarketCloseValue, :accountType, :cusip, :securityDescription
    attr_reader :securityClass, :previousClosePrice, :realTimePrice, :realTimePrice, :realTimeMarketValue, :priceChange
    
    def initialize(details)
      @symbol = details["symbol"]
      @displaySymbol = details["displaySymbol"]
      @quantity = details["quantity"]
      @previousMarketCloseValue = Money.parse(details["prevCloseMktValue"])
      @accountType = details["accType"]
      @cusip = details["cusip"]
      @securityDescription = details["securityDescription"]
      @securityClass = details["SecurityClass"]
      @previousClosePrice = details["previousClosePrice"]
      @realTimePrice = details["realTimePrice"]
      @realTimeMarketValue = Money.parse(details["RealTimeMktValue"])
      @priceChange = Money.parse(details["priceChange"])
    end
  end
end