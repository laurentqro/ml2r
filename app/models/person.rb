class Person < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches

  has_many :business_relationships, as: :clientable

  def name
    "#{last_name}, #{first_name}"
  end

  def country
    country_of_residence
  end
end
