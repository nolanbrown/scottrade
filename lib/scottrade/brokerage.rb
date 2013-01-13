require 'money'
require_relative 'account'
require_relative 'position'
require_relative 'helpers'

module Scottrade
  class Brokerage 
    include Scottrade::Helpers
    
    attr_reader :total_value, :total_cash_balance, :yesterday_total_cash_balance, :available_free_cash_blanace, :account_balance
    attr_reader :total_market_value_with_options, :total_market_value_without_options, :yesterday_total_market_value
    attr_reader :total_settled_funds, :total_unsettled_sells, :funds_available_to_buy_non_marginables, :funds_available_to_buy_marginables
    attr_reader :funds_available_to_buy_options, :funds_available_to_buy_mutual_funds, :funds_available_for_withdraw, :approximate_liquidation_value
    attr_reader :accounts, :positions
    attr_reader :current_market_value, :todays_percent_change, :todays_value_change
    
    def initialize(session)
      @session = session
    end
    
    # def positions
    # 
    # end
    # def accounts
    # end
    
    def update_accounts
      params = request_parameters("GetFrontEndMoneyBalances")
            
      response = @session.post(params)
      parsed_response = JSON.parse(response.body)
      if parsed_response["error"] == "false"
        @total_value = Money.parse parsed_response["TotalAccountValue"]
        @total_cash_balance = Money.parse parsed_response["TotalMoneyBalance"]
        @yesterday_total_cash_balance = Money.parse parsed_response["YesterdayTotalMoneyBalance"]
        @available_free_cash_blanace = Money.parse parsed_response["AvailableFreeCash"]
        @total_market_value_with_options = Money.parse parsed_response["TotalMarketValueWithOptions"]
        @total_market_value_without_options = Money.parse parsed_response["TotalMarketValueNoOptions"]
        @yesterday_total_market_value = Money.parse parsed_response["YesterdayTotalMarketValue"]
        @total_settled_funds = Money.parse parsed_response["TotalSettledFunds"]
        @total_unsettled_sells = Money.parse parsed_response["TotalUnsettledSells"]
        @funds_available_to_buy_non_marginables = Money.parse parsed_response["FundsAvailableToBuyNonMarginables"]
        @funds_available_to_buy_marginables = Money.parse parsed_response["FundsAvailableToBuyMarginables"]
        @funds_available_to_buy_options = Money.parse parsed_response["FundsAvailableToBuyOptions"]
        @funds_available_to_buy_mutual_funds = Money.parse parsed_response["FundsAvailableToBuyMutualFunds"]
        @funds_available_for_withdraw = Money.parse parsed_response["FundsAvailableForWithdraw"]
        @approximate_liquidation_value = Money.parse parsed_response["TodaysChangeApproxLiquidationValNoOptions"]
        @account_balance = Money.parse parsed_response["BrokerageAccountBalance"]
        
        @accounts = []
        unparsed_accounts = parsed_response["AccTypeBalances"]
        unparsed_accounts.each{|acct|
          @accounts.push Account.new(acct)
        }
        
      elsif parsed_response["msg"]
        raise RequestError, parsed_response["msg"]
      else
        raise RequestError
      end
    end
    
    def update_positions
      params = request_parameters("GetPositions_v2")
      params["startRow"] = "0"
      params["noOfRows"] = "1000"
      params["returnRealTimeMktValue"] = "true"
      
      params["serviceID"] = "GetPositions_v2"
            
      response = @session.post(params)
      parsed_response = JSON.parse(response.body)
      if parsed_response["error"] == "false"

        @current_market_value = parsed_response["totalMktValue"]
        @todays_percent_change = parsed_response["totalPctChange"]
        @todays_value_change = parsed_response["toalPriceChange"]
        
        @positions = []
        all_positions = parsed_response["Positions"]
        all_positions.each{|pos|
          @positions.push Position.new(pos)
        }
        
      elsif parsed_response["msg"]
        raise RequestError, parsed_response["msg"]
      else
        raise RequestError
      end
    end    
    
  end
end