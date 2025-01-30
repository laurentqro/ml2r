class Person < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches

  has_many :business_relationships, class_name: "Client", as: :clientable

  validates :first_name, :last_name, presence: true
  validates :country_of_birth, :country_of_residence, :country_of_profession, presence: true
  validates :profession, presence: true
  validates :pep, inclusion: { in: [ true, false ] }

  def name
    last_name
  end

  def display_name
    "#{last_name}, #{first_name}".strip.chomp(",")
  end

  def country
    country_of_residence
  end
end
