class Company < ApplicationRecord
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches
  has_many :business_relationships, class_name: "Client", as: :clientable

  # Add company relationships
  has_many :company_relationships, dependent: :destroy
  has_many :related_people, through: :company_relationships, source: :person

  # Specific relationship types
  has_many :director_relationships, -> { directors }, class_name: "CompanyRelationship"
  has_many :beneficial_owner_relationships, -> { beneficial_owners }, class_name: "CompanyRelationship"
  has_many :legal_representative_relationships, -> { legal_representatives }, class_name: "CompanyRelationship"

  # People by relationship type
  has_many :directors, through: :director_relationships, source: :person
  has_many :beneficial_owners, through: :beneficial_owner_relationships, source: :person
  has_many :legal_representatives, through: :legal_representative_relationships, source: :person

  validates :name, :country, presence: true

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

  def pep?
    false
  end

  def identification_documents
    []
  end
end
