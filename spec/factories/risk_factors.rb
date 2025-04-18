FactoryBot.define do
  factory :risk_factor do
    association :client
    category { "client_risk" }
    identifier { "rushed_transactions" }
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
