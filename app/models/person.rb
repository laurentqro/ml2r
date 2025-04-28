class Person < ApplicationRecord
  DOCUMENT_TYPES = [
    "Passport",
    "ID Card",
    "Driver License",
    "Residence Permit"
  ].freeze

  has_many :business_relationships, class_name: "Client", as: :clientable
  has_many :screenings, as: :screenable
  has_many :screening_matches, through: :screenings, source: :matches
  has_many :adverse_media_checks, as: :adverse_media_checkable
  has_many :identification_documents, as: :documentable, dependent: :destroy

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

  default_scope { order(last_name: :asc) }

  scope :clear, -> {
    where("NOT EXISTS (
      SELECT 1 FROM people
      WHERE people.sanctioned = true
    )")
  }

  scope :sanctioned, -> {
    where("EXISTS (
      SELECT 1 FROM people
      WHERE people.sanctioned = true
    )")
  }

  scope :pep, -> {
    where("people.pep = ?", true)
  }

  scope :with_adverse_media, -> {
    where("EXISTS (
      SELECT 1 FROM adverse_media_checks
      WHERE adverse_media_checks.adverse_media_checkable_id = people.id
      AND adverse_media_checks.adverse_media_checkable_type = 'Person'
    )")
  }

  def name
    last_name
  end

  def last_name_first_name
    "#{last_name.upcase}, #{first_name}"
  end

  def display_name
    "#{first_name} #{last_name.upcase}".strip.chomp(",")
  end

  def country
    country_of_residence
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
    !pep? && !sanctioned? && !has_adverse_media?
  end
end
