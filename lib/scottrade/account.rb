
module Scottrade
  
  class Account 
    CASH_ACCOUNT = "Cash"
    MARGIN_ACCOUNT = "Margin"
    SHORT_ACCOUNT = "Short"
    attr_reader :type, :settled_funds, :market_value, :yesterday_market_value, :total_available_for_trading, :deposited_funds, :total_value
    
    def initialize(details={})
      @type = details["AccountType"]
      @settled_funds = Money.parse details["SettledFunds"]
      @market_value = Money.parse details["MarketValue"]
      @yesterday_market_value = Money.parse details["YesterdayMarketValue"]
      
      @total_available_for_trading = Money.parse details["TotalAccountTypeFundsForTrading"]
      @deposited_funds = Money.parse details["BankDepositProgramForTrading"]
      
      @total_value = Money.parse details["TotalAccountTypeValue"]
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