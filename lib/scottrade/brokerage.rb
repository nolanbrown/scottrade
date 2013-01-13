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
    
    KEYS_TO_VARIABLES = {
      # accounts data keys
      "TotalAccountValue"                         => { :key => :total_value, :is_money => true },
      "TotalMoneyBalance"                         => { :key => :total_cash_balance, :is_money => true },
      "YesterdayTotalMoneyBalance"                => { :key => :yesterday_total_cash_balance, :is_money => true },
      "AvailableFreeCash"                         => { :key => :available_free_cash_blanace, :is_money => true },
      "TotalMarketValueWithOptions"               => { :key => :total_market_value_with_options, :is_money => true },
      "TotalMarketValueNoOptions"                 => { :key => :total_market_value_without_options, :is_money => true },
      "YesterdayTotalMarketValue"                 => { :key => :yesterday_total_market_value, :is_money => true },
      "TotalSettledFunds"                         => { :key => :total_settled_funds, :is_money => true },
      "TotalUnsettledSells"                       => { :key => :total_unsettled_sells, :is_money => true },
      "FundsAvailableToBuyNonMarginables"         => { :key => :funds_available_to_buy_non_marginables, :is_money => true },
      "FundsAvailableToBuyMarginables"            => { :key => :funds_available_to_buy_marginables, :is_money => true },
      "FundsAvailableToBuyOptions"                => { :key => :funds_available_to_buy_options, :is_money => true },
      "FundsAvailableToBuyMutualFunds"            => { :key => :funds_available_to_buy_mutual_funds, :is_money => true },
      "FundsAvailableForWithdraw"                 => { :key => :funds_available_for_withdraw, :is_money => true },
      "TodaysChangeApproxLiquidationValNoOptions" => { :key => :approximate_liquidation_value, :is_money => true },
      "BrokerageAccountBalance"                   => { :key => :account_balance, :is_money => true },
      # positions data keys
      "totalMktValue"                             => { :key => :current_market_value, :is_money => false },
      "totalPctChange"                            => { :key => :todays_percent_change,  :is_money => false },
      "toalPriceChange"                           => { :key => :todays_value_change, :is_money => false },
    }

    
    def initialize(session)
      @session = session
    end
    
    def update_accounts
      params = request_parameters("GetFrontEndMoneyBalances")
            
      response = session_post(params)
      set_variables_from_response(response)

      @accounts = []
      unparsed_accounts = response["AccTypeBalances"]
      unparsed_accounts.each{|acct|
        @accounts.push Account.new(acct)
      }
      
    end
    
    def update_positions
      params = request_parameters("GetPositions_v2")
      params["startRow"] = "0"
      params["noOfRows"] = "1000"
      params["returnRealTimeMktValue"] = "true"
      
      params["serviceID"] = "GetPositions_v2"
      
      response = session_post(params)
      
      set_variables_from_response(response)
      
      @positions = []
      all_positions = response["Positions"]
      all_positions.each{|pos|
        @positions.push Position.new(pos)
      }
    end    
    
    private
    def session_post(params)
      response = @session.post(params)
      parsed_response = JSON.parse(response.body)
      if parsed_response["error"] == "false"
        return parsed_response
      elsif parsed_response["msg"]
        raise RequestError, parsed_response["msg"]
      else
        raise RequestError
      end
    end
    
    def set_variables_from_response(response)
      response.each{|key,value|
        settings = KEYS_TO_VARIABLES[key]
        if settings[:is_money]
          value = Money.parse value
        end
        instance_variable_set("@#{settings[:key].to_s}", value)
      }
    end
  end
end