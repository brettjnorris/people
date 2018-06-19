class SalesforceApi
  API_KEY = ENV["SALESLOFT_APPLICATION_ID"] || ""

  def self.fetch(endpoint, params = {})
    url = "http://api.salesloft.com/v2/" + endpoint
    options = {
      "Authorization" => "Bearer #{API_KEY}",
      "params" => params
    }

    RestClient.get url, options 
  end
end