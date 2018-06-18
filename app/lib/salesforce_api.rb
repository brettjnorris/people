class SalesforceApi
  API_KEY = ENV["SALESLOFT_APPLICATION_ID"] || ""

  def self.fetch(endpoint)
    url = "http://api.salesloft.com/v2/" + endpoint
    headers = { 
      "Authorization" => "Bearer #{API_KEY}" 
    }

    RestClient.get url, headers
  end
end