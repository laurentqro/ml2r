class Person < ApplicationRecord
  has_many :business_relationships, class_name: "Client", as: :clientable
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches
  has_many :identification_documents, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :country_of_birth, :country_of_residence, :country_of_profession, presence: true
  validates :profession, presence: true
  validates :pep, inclusion: { in: [ true, false ] }

  accepts_nested_attributes_for :identification_documents, allow_destroy: true, reject_if: :all_blank

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
