require 'test/unit'
require 'rack/test'
require '../../lib/scottrade'
class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_brokerage_balances
    scottrade = Scottrade::Scottrade.new(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
    assert_nothing_raised Scottrade::AuthenticationError do
      scottrade.authenticate
    end
    assert_nothing_raised Scottrade::RequestError do
      scottrade.brokerage.update_accounts
    end
  end
  def test_brokerage_positions
    scottrade = Scottrade::Scottrade.new(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
    assert_nothing_raised Scottrade::AuthenticationError do
      scottrade.authenticate
    end
    assert_nothing_raised Scottrade::RequestError do
      scottrade.brokerage.update_positions
    end
  end
end