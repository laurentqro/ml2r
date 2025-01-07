class Occupation < ApplicationRecord
  def long_description
    "#{major_label} > #{description}"
  end
end
