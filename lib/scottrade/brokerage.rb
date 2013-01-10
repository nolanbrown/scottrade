require_relative 'account'
require_relative 'position'

module Scottrade
  class Brokerage 
    
    attr_reader :totalValue, :totalCashBalance, :yesterdayTotalCashBalance, :availableFreeCashBlanace
    attr_reader :totalMarketValueWithOptions, :totalMarketValueWithoutOptions, :yesterdayTotalMarketValue
    attr_reader :totalSettledFunds, :totalUnsettledSells, :fundsAvailableToBuyNonMarginables, :fundsAvailableToBuyMarginables
    attr_reader :fundsAvailableToBuyOptions, :fundsAvailableToBuyMutualFunds, :fundsAvailableForWithdraw, :approximateLiquidationValue
    attr_reader :accounts, :positions
    attr_reader :currentMarketValue, :todaysPercentChange, :todaysValueChange
    
    def initialize(session)
      @session = session
    end
    
    # def positions
    # 
    # end
    # def accounts
    # end
    
    def update_accounts
      params = {}
      params["channel"] = "rc"
      params["appID"] = "Scottrade"
      params["rcid"] = "iPhone"
      params["cacheid"] = ""
      params["platform"] = "iPhone"
      params["appver"] = "1.1.4"
      params["useCachedData"] = "false"
            
      params["serviceID"] = "GetFrontEndMoneyBalances"
            
      response = @session.post(params)
      parsed_response = JSON.parse(response.body)
      if parsed_response["error"] == "false"
        @totalValue = parsed_response["TotalAccountValue"]
        @totalCashBalance = parsed_response["TotalMoneyBalance"]
        @yesterdayTotalCashBalance = parsed_response["YesterdayTotalMoneyBalance"]
        @availableFreeCashBlanace = parsed_response["AvailableFreeCash"]
        @totalMarketValueWithOptions = parsed_response["TotalMarketValueWithOptions"]
        @totalMarketValueWithoutOptions = parsed_response["TotalMarketValueNoOptions"]
        @yesterdayTotalMarketValue = parsed_response["YesterdayTotalMarketValue"]
        @totalSettledFunds = parsed_response["TotalSettledFunds"]
        @totalUnsettledSells = parsed_response["TotalUnsettledSells"]
        @fundsAvailableToBuyNonMarginables = parsed_response["FundsAvailableToBuyNonMarginables"]
        @fundsAvailableToBuyMarginables = parsed_response["FundsAvailableToBuyMarginables"]
        @fundsAvailableToBuyOptions = parsed_response["FundsAvailableToBuyOptions"]
        @fundsAvailableToBuyMutualFunds = parsed_response["FundsAvailableToBuyMutualFunds"]
        @fundsAvailableForWithdraw = parsed_response["FundsAvailableForWithdraw"]
        @approximateLiquidationValue = parsed_response["TodaysChangeApproxLiquidationValNoOptions"]
        @accountBalance = parsed_response["BrokerageAccountBalance"]
        
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
      params = {}
      params["channel"] = "rc"
      params["appID"] = "Scottrade"
      params["rcid"] = "iPhone"
      params["cacheid"] = ""
      params["platform"] = "iPhone"
      params["appver"] = "1.1.4"
      
      params["useCachedData"] = "false"
      params["startRow"] = "0"
      params["noOfRows"] = "1000"
      params["returnRealTimeMktValue"] = "true"
      
      params["serviceID"] = "GetPositions_v2"
            
      response = @session.post(params)
      parsed_response = JSON.parse(response.body)
      if parsed_response["error"] == "false"

        @currentMarketValue = parsed_response["totalMktValue"]
        @todaysPercentChange = parsed_response["totalPctChange"]
        @todaysValueChange = parsed_response["toalPriceChange"]
        
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