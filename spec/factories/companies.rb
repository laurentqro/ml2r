FactoryBot.define do
  factory :company do
    name { "Test Company #{SecureRandom.hex(4)}" }
    country { "GB" }
  end
end
