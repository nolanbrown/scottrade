require 'test/unit'
require 'rack/test'
require_relative '../../lib/scottrade'
require_relative 'helpers'

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include ScottradeUnitTestHelpers
  
  def test_positive_authentication
    authenticate(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
  end
  def test_negative_authentication
    authenticate("555555555","password")
  end
end