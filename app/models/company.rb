class Company < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches

  has_many :business_relationships, class_name: "Client", as: :clientable

  def display_name
    name
  end

  def pep?;end
end
