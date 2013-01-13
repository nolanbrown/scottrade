require 'json'

require_relative 'base'
require_relative 'error'
require_relative 'helpers'

module Scottrade
  class Session < Base
    include Scottrade::Helpers
    
    attr_reader :encrypted_id, :mask_id
    
    def initialize(account, password)
      @account = account
      @password = password
      @cookies = nil
    end
    def authenticated?
      return (@cookies != nil)
    end
    def authenticate
      params = request_parameters("VerifyLogin")
      params["appName"] = "ScottradeMobileApplication"
      params["appVer"] = "1.1.4"
      params["isRemAcc"] = "true"
      params["page"] = "LogIn"
      params["langId"] = "English"      
      
      params["acc"] = @account
      params["pwd"] = @password
      params["isEncrypted"] = "false"
            
      response = post(params, nil)
      all_cookies = response.get_fields('set-cookie') # only cookies are set on valid credentials
      parsed_response = JSON.parse(response.body)
      if parsed_response["error"] == "false" and !parsed_response.has_key?("errmsg")
        cookies = []
        all_cookies.each { | cookie |
            cookies.push(cookie.split('; ')[0])
        }
        @cookies = cookies
        @encrypted_dd = parsed_response["encryptedId"]
        @mask_id = parsed_response["maskId"]
        
        return self
      elsif parsed_response["msg"]
        raise AuthenticationError, parsed_response["msg"]
      elsif parsed_response["errmsg"]
        raise AuthenticationError, parsed_response["errmsg"]
      else
        raise AuthenticationError
      end   
    end
  end
end