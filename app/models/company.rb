class Company < ApplicationRecord
  DOCUMENT_TYPES = [
    "Articles of Association",
    "Shareholder Register",
    "Board Minutes",
    "Annual Return",
    "Other"
  ].freeze

  has_many :business_relationships, class_name: "Client", as: :clientable
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches
  has_many :adverse_media_checks, as: :adverse_media_checkable
  has_many :identification_documents, as: :documentable, dependent: :destroy

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

  accepts_nested_attributes_for :identification_documents, allow_destroy: true, reject_if: :all_blank

  scope :clear, -> {
    where("NOT EXISTS (
      SELECT 1 FROM companies
      WHERE companies.sanctioned = true
    )")
  }

  scope :sanctioned, -> {
    where("EXISTS (
      SELECT 1 FROM companies
      WHERE companies.sanctioned = true
    )")
  }

  scope :with_adverse_media, -> {
    where("EXISTS (
      SELECT 1 FROM adverse_media_checks
      WHERE adverse_media_checks.adverse_media_checkable_id = companies.id
      AND adverse_media_checks.adverse_media_checkable_type = 'Company'
    )")
  }

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

  def client?
    Client.exists?(clientable: self)
  end

  def has_adverse_media?
    adverse_media_checks.any?(&:adverse_media_found?)
  end

  def latest_screening
    screenings.order(created_at: :desc).first
  end

  def clear?
    !sanctioned? && !has_adverse_media?
  end
end
