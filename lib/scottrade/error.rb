module Scottrade
  class AuthenticationError < StandardError
    def initialize(msg = "Authentication Error")
      super(msg)
    end
  end
  class UnkownError < StandardError
    def initialize(msg = "Unkown Error")
      super(msg)
    end
  end
  class RequestError < StandardError
    def initialize(msg = "Request Error")
      super(msg)
    end
  end
end