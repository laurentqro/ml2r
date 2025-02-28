FactoryBot.define do
  factory :occupation do
    major { "1" }
    major_label { "Business" }
    sub_major { "11" }
    sub_major_label { "Chief Executives" }
    minor { "111" }
    minor_label { "Chief Executives and Managing Directors" }
    unit { "1111" }
    description { "Chief Executive Officer" }
  end
end
