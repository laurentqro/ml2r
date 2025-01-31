FactoryBot.define do
  factory :risk_factor do
    association :client
    category { :business_relationship }
    identifier { 'not_identified_personally' }
    identified_at { nil }
    notes { nil }

    trait :active do
      identified_at { Time.current }
    end

    trait :with_notes do
      notes { "Important risk factor notes" }
    end
  end
end
