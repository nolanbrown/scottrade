module ScottradeUnitTestHelpers
  def authenticate(username, password)
    scottrade = Scottrade::Scottrade.new(username, password)
    assert_nothing_raised Scottrade::AuthenticationError do
      scottrade.authenticate
    end
  end
end