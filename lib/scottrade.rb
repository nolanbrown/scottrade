require_relative "scottrade/version"
require_relative "scottrade/session"
require_relative "scottrade/brokerage"

module Scottrade
  class Scottrade
    attr_reader :session
    def initialize(account, password)
      @session = Session.new(account, password)
      ## 
    end
    def authenticate
      response = @session.authenticate
      if @session.authenticated?
        return @session
      else # error
        return response
      end
    end
    def authenticated?
      return @session.authenticated?
    end
    
    def brokerage
      return @brokerage if @brokerage
      @brokerage = Brokerage.new(@session)
    end
    
  end
end
