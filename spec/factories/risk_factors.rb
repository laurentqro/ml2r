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

  factory :person_risk_factor do
    client
    category { :behavioral }
    identifier { 'rushed_transactions' }
    identified_at { Time.current }
  end

  factory :company_risk_factor do
    client
    category { :financing }
    identifier { 'financed_by_beneficial_owners' }
    identified_at { Time.current }
  end
end
