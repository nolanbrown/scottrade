require 'uri'
require 'net/http'
require 'json'

module Scottrade
  class Base
    attr_accessor :session_token, :cookies
    ::API_BASE = "https://mobappfe.scottrade.com"
    ::API_PATH = "/middleware/MWServlet"
    
    def post(parameters, cookies = nil)
      uri = URI.parse(API_BASE)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
      request = Net::HTTP::Post.new(API_PATH)
      request.set_form_data(parameters)
      
      cookies = @cookies unless cookies
      
      request.add_field("Cookie",cookies.join('; ')) if cookies

      response = http.request(request)
      
      return response
    end
    
    def get(path, parameters,cookies=nil)
      uri = URI.parse(API_BASE)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                  
      query_path = "#{path}"
      query_path = "#{path}?#{URI.encode_www_form(parameters)}" if parameters.length > 0
      request = Net::HTTP::Get.new(query_path)      
      
      cookies = @cookies unless cookies
      
      request.add_field("Cookie",cookies.join('; ')) if cookies
            
      response = http.request(request)
      return response
    end
  end
  
end