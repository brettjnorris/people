class Person
  def self.all
    response = SalesforceApi.fetch("people.json")
    json = JSON.parse(response.body)

    json["data"].present? ? json["data"] : []
  end

  def self.character_frequency
    character_counts = {}

    Person.all.each do |person|
      email = person["email_address"].gsub(/\W/, "")

      email.chars.each do |char|
        if character_counts[char]
          character_counts[char] += 1
        else
          character_counts[char] = 1
        end
      end
    end

    character_counts.sort.to_h
  end
end