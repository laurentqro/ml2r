class Company < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches

  has_many :business_relationships, as: :clientable
end
