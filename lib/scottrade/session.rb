require 'json'

require_relative 'base'
require_relative 'error'

module Scottrade
  class Session < Base
    
    attr_reader :encryptedId, :maskId
    
    def initialize(account, password)
      @account = account
      @password = password
      @cookies = nil
    end
    def authenticated?
      return (@cookies != nil)
    end
    def authenticate
      params = {}
      params["appID"] = "Scottrade"
      params["appName"] = "ScottradeMobileApplication"
      params["rcid"] = "iPhone"
      params["osName"] = "iPhone"
      params["platform"] = "iPhone"
      params["cacheid"] = ""
      params["osVer"] = "6"
      params["appver"] = "1.1.4"
      params["appVer"] = "1.1.4"
      params["isRemAcc"] = "true"
      params["page"] = "LogIn"
      params["serviceID"] = "VerifyLogin"
      params["channel"] = "rc"
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
        @encryptedId = parsed_response["encryptedId"]
        @maskId = parsed_response["maskId"]
        
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