FactoryBot.define do
  factory :person do
    first_name { "John" }
    last_name { "Doe" }
    country_of_birth { "FR" }
    country_of_residence { "FR" }
    country_of_profession { "FR" }
    profession { "Developer" }
    pep { false }
  end
end
