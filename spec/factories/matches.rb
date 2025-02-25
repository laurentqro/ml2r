FactoryBot.define do
  factory :match do
    association :screening

    external_data do
      {
        "schema" => "Person",
        "caption" => "John Smith",
        "score" => 0.85,
        "properties" => {
          "firstName" => [ "John" ],
          "lastName" => [ "Smith" ],
          "alias" => [ "Johnny", "J. Smith" ],
          "nationality" => [ "US" ],
          "birthDate" => [ "1980-01-01" ],
          "address" => [ "123 Main St" ],
          "topics" => [ "role.pep", "sanction.linked" ],
          "country" => [ "US", "GB" ],
          "citizenship" => [ "US" ]
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
          "properties" => {
            "name" => [ "Acme Corporation" ],
            "topics" => [ "sanction.linked" ],
            "country" => [ "RU" ]
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
