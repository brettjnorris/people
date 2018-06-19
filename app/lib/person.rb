class Person
  def self.all
    people = []

    page_size = 100
    current_page = 1

    loop do
      break if current_page.nil?

      response = SalesforceApi.fetch("people.json", {
        per_page: page_size,
        page: current_page
      })

      json = JSON.parse(response.body)
      data = json["data"]
      people = people.push(*data) if data.present?

      if paging = json["metadata"]["paging"]
        current_page = paging["next_page"]
      else
        current_page = nil
      end
    end

    people
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