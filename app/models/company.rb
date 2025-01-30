class Company < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches
  has_many :business_relationships, class_name: "Client", as: :clientable

  def country_of_residence
    country
  end

  def nationality
    nil
  end

  def country_of_profession
    nil
  end

  def country_of_birth
    nil
  end

  def display_name
    name
  end

  def pep?;end
end
