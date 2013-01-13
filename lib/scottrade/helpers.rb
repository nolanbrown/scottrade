
module Scottrade
  module Helpers    
    def request_parameters(serviceID)
      params = {}
      params["channel"] = "rc"
      params["appID"] = "Scottrade"
      params["rcid"] = "iPhone"
      params["cacheid"] = ""
      params["platform"] = "iPhone"
      params["appver"] = "1.1.4"
      params["useCachedData"] = "false"      
      params["serviceID"] = serviceID
      params
    end
  end
end