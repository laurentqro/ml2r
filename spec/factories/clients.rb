FactoryBot.define do
  factory :client do
    clientable { create(:person) }
    risk_factors { [] }
  end
end
