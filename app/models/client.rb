class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true

  has_many :risk_assessments, dependent: :destroy
  has_many :risk_factors, through: :risk_assessments
  has_many :risk_scoresheets, dependent: :destroy
  has_many :adverse_media_checks, dependent: :destroy

  delegate :display_name, :country_of_residence, :nationality, :country_of_profession,
           :country_of_birth,
           to: :clientable, allow_nil: true

  validate :no_blacklisted_countries

  accepts_nested_attributes_for :clientable

  scope :clear, -> {
    where("NOT EXISTS (
      SELECT 1 FROM people
      WHERE people.id = clients.clientable_id
      AND clients.clientable_type = 'Person'
      AND people.sanctioned = true
    ) AND NOT EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = clients.clientable_id
      AND clients.clientable_type = 'Company'
      AND companies.sanctioned = true
    )")
  }

  scope :sanctioned, -> {
    where("EXISTS (
      SELECT 1 FROM people
      WHERE people.id = clients.clientable_id
      AND clients.clientable_type = 'Person'
      AND people.sanctioned = true
    ) OR EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = clients.clientable_id
      AND clients.clientable_type = 'Company'
      AND companies.sanctioned = true
    )")
  }

  scope :pep, -> {
    joins("LEFT JOIN people ON clients.clientable_id = people.id AND clients.clientable_type = 'Person'")
      .where("people.pep = ?", true)
  }

  def country_risk_score
    latest_risk_scoresheet&.country_risk_score || 0
  end

  def client_risk_score
    latest_risk_scoresheet&.client_risk_score || 0
  end

  def products_and_services_risk_score
    latest_risk_scoresheet&.products_and_services_risk_score || 0
  end

  def distribution_channel_risk_score
    latest_risk_scoresheet&.distribution_channel_risk_score || 0
  end

  def transaction_risk_score
    latest_risk_scoresheet&.transaction_risk_score || 0
  end

  def current_risk_assessment
    risk_assessments.current
  end

  def latest_approved_risk_assessment
    risk_assessments.approved.order(approved_at: :desc).first
  end

  def total_risk_score
    latest_risk_assessment&.total_risk_score || 0
  end

  def latest_risk_assessment
    risk_assessments.order(created_at: :desc).first
  end

  def current_risk_factors
    current_risk_assessment&.risk_factors || RiskFactor.none
  end

  def has_adverse_media?
    adverse_media_checks.any?(&:adverse_media_found?)
  end

  def pep?
    clientable.pep
  end

  def latest_risk_scoresheet
    risk_scoresheets.current || RiskScoresheet.new(
      client: self,
      country_risk_score: 0,
      client_risk_score: 0,
      products_and_services_risk_score: 0,
      distribution_channel_risk_score: 0,
      transaction_risk_score: 0
    )
  end

  def company?
    clientable_type == "Company"
  end

  def person?
    clientable_type == "Person"
  end

  private

  def no_blacklisted_countries
    if blacklisted?
      errors.add(:base, "Cannot onboard clients with ties to GAFI blacklisted countries")
    end
  end

  def blacklisted?
    [ country_of_residence, nationality, country_of_profession, country_of_birth ].compact.any? do |country|
      ::CountryRiskScorer.gafi_status(country) == :black
    end
  end
end
