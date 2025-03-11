class Person < ApplicationRecord
  has_many :business_relationships, class_name: "Client", as: :clientable
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches
  has_many :identification_documents, dependent: :destroy

  # Add company relationships
  has_many :company_relationships, dependent: :destroy
  has_many :related_companies, through: :company_relationships, source: :company

  # Specific relationship types
  has_many :director_of_relationships, -> { directors }, class_name: "CompanyRelationship"
  has_many :beneficial_owner_of_relationships, -> { beneficial_owners }, class_name: "CompanyRelationship"
  has_many :legal_representative_of_relationships, -> { legal_representatives }, class_name: "CompanyRelationship"

  # Companies by relationship type
  has_many :director_of_companies, through: :director_of_relationships, source: :company
  has_many :beneficial_owner_of_companies, through: :beneficial_owner_of_relationships, source: :company
  has_many :legal_representative_of_companies, through: :legal_representative_of_relationships, source: :company

  validates :first_name, :last_name, presence: true
  validates :country_of_birth, :country_of_residence, :country_of_profession, presence: true
  validates :profession, presence: true

  accepts_nested_attributes_for :identification_documents, allow_destroy: true, reject_if: :all_blank

  def name
    last_name
  end

  def display_name
    "#{first_name} #{last_name.upcase}".strip.chomp(",")
  end

  def country
    country_of_residence
  end
end
