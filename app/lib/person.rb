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

  def self.group_duplicates
    duplicates = []

    people = Person.all

    loop do
      break if people.empty?

      person = people.shift

      people.each do |p|
        if Person.distance(person["email_address"], p["email_address"]) < 2
          duplicates.push([person, p])
        end
      end
    end

    duplicates
  end

  def self.distance(a, b, len_a = nil, len_b = nil)
    a, b = a.downcase.gsub(/(\W)/, ""), b.downcase.gsub(/(\W)/, "")

    len_a = a.length unless len_a
    len_b = b.length unless len_b

    return len_b if len_a == 0
    return len_a if len_b == 0

    if a.chars[len_a - 1] == b.chars[len_b - 1]
      cost = 0
    else
      cost = 1
    end

    [
      self.distance(a, b, len_a - 1, len_b    ) + 1,
      self.distance(a, b, len_a,     len_b - 1) + 1,
      self.distance(a, b, len_a - 1, len_b - 1) + cost
    ].min
  end
end