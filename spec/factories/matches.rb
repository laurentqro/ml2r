FactoryBot.define do
  factory :match do
    association :screening

    external_data do
      {
        "schema" => "Person",
        "caption" => "John Smith",
        "score" => 0.85,
        "last_change" => Time.now.iso8601,
        "last_seen" => Time.now.iso8601,
        "first_seen" => (Time.now - 30.days).iso8601,
        "properties" => {
          "name" => [ "John Smith" ],
          "firstName" => [ "John" ],
          "lastName" => [ "Smith" ],
          "fatherName" => [ "Robert" ],
          "secondName" => [ "Michael" ],
          "title" => [ "Mr." ],
          "alias" => [ "Johnny", "J. Smith" ],
          "weakAlias" => [ "JS", "Smith" ],
          "nationality" => [ "US" ],
          "birthDate" => [ "1980-01-01" ],
          "birthPlace" => [ "New York" ],
          "birthCountry" => [ "United States" ],
          "birthCity" => [ "New York" ],
          "birthState" => [ "New York" ],
          "birthCountryCode" => [ "US" ],
          "birthStateCode" => [ "NY" ],
          "birthDateAccuracy" => [ "day" ],
          "gender" => "male",
          "address" => [ "123 Main St" ],
          "topics" => [ "role.pep", "sanction.linked" ],
          "country" => [ "US", "GB" ],
          "citizenship" => [ "US" ],
          "wikidataId" => [ "Q12345" ],
          "position" => [ "CEO" ],
          "education" => [ "Harvard University" ],
          "religion" => [ "Christianity" ],
          "ethnicity" => [ "Caucasian" ],
          "sourceUrl" => [ "https://example.com" ],
          "website" => [ "https://johnsmith.com" ]
        },
        "datasets" => [ "us_ofac", "eu_fsf" ]
      }
    end

    trait :organization do
      external_data do
        {
          "schema" => "Organization",
          "caption" => "Acme Corp",
          "score" => 0.7,
          "last_change" => Time.now.iso8601,
          "last_seen" => Time.now.iso8601,
          "first_seen" => (Time.now - 30.days).iso8601,
          "properties" => {
            "name" => [ "Acme Corporation" ],
            "topics" => [ "sanction.linked" ],
            "country" => [ "RU" ],
            "website" => [ "https://acmecorp.com" ]
          },
          "datasets" => [ "us_ofac" ]
        }
      end
    end

    trait :without_data do
      external_data { nil }
    end
  end
end
