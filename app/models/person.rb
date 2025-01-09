class Person < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches

  def last_first_name
    "#{last_name}, #{first_name}"
  end
end
