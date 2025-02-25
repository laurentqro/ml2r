FactoryBot.define do
  factory :screening do
    association :screenable, factory: :client
  end
end
