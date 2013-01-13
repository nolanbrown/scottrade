require 'test/unit'
require 'rack/test'
require_relative 'helpers'
require_relative '../../lib/scottrade'

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include ScottradeUnitTestHelpers
  def test_brokerage_balances
    authenticate(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
    
    assert_nothing_raised Scottrade::RequestError do
      scottrade.brokerage.update_accounts
    end
  end
  def test_brokerage_positions
    authenticate(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
    
    assert_nothing_raised Scottrade::RequestError do
      scottrade.brokerage.update_positions
    end
  end
  
end