require 'money'

module Scottrade
  
  class Account 
    CASH_ACCOUNT = "Cash"
    MARGIN_ACCOUNT = "Margin"
    SHORT_ACCOUNT = "Short"
    attr_reader :type, :settledFunds, :marketValue, :yesterdayMarketValue, :totalAvailableForTrading, :depositedFunds, :totalValue
    
    def initialize(details={})
      @type = details["AccountType"]
      @settledFunds = Money.parse details["SettledFunds"]
      @marketValue = Money.parse details["MarketValue"]
      @yesterdayMarketValue = Money.parse details["YesterdayMarketValue"]
      
      @totalAvailableForTrading = Money.parse details["TotalAccountTypeFundsForTrading"]
      @depositedFunds = Money.parse details["BankDepositProgramForTrading"]
      
      @totalValue = Money.parse details["TotalAccountTypeValue"]
    end
    
    def cash?
      @type == CASH_ACCOUNT
    end
    def margin?
      @type == MARGIN_ACCOUNT
    end
    def short?
      @type == SHORT_ACCOUNT
    end
  end
end