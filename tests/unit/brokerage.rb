require 'test/unit'
require 'rack/test'
require_relative '../../lib/scottrade'
class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_brokerage_balances
    authenticate
    
    assert_nothing_raised Scottrade::RequestError do
      scottrade.brokerage.update_accounts
    end
  end
  def test_brokerage_positions
    authenticate
    
    assert_nothing_raised Scottrade::RequestError do
      scottrade.brokerage.update_positions
    end
  end
  
  private
  def authenticate
    scottrade = Scottrade::Scottrade.new(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
    assert_nothing_raised Scottrade::AuthenticationError do
      scottrade.authenticate
    end
  end
  
end