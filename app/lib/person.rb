class Person
  def self.all
    response = SalesforceApi.fetch("people.json")
    json = JSON.parse(response.body)

    json["data"].present? ? json["data"] : []
  end
end