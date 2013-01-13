require 'test/unit'
require 'rack/test'
require_relative '../../lib/scottrade'

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_positive_authentication
    scottrade = Scottrade::Scottrade.new(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
    assert_nothing_raised Scottrade::AuthenticationError do
      scottrade.authenticate
    end
  end
  def test_negative_authentication
    scottrade = Scottrade::Scottrade.new("555555555","password")
    assert_raise Scottrade::AuthenticationError do
      scottrade.authenticate
    end
  end
end