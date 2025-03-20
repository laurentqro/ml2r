class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true

  has_many :risk_factors, dependent: :destroy
  has_many :risk_scoresheets, dependent: :destroy
  has_many :adverse_media_checks, dependent: :destroy

  delegate :display_name, :country_of_residence, :nationality, :country_of_profession,
           :country_of_birth, to: :clientable, allow_nil: true

  validate :no_blacklisted_countries

  accepts_nested_attributes_for :clientable
  accepts_nested_attributes_for :risk_factors, allow_destroy: true,
    reject_if: proc { |attributes| attributes["identified_at"].blank? }

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

  def total_risk_score
    country_risk_score + total_risk_factors_score
  end

  def total_risk_factors_score
    RiskFactor.where(client: self).sum do |risk_factor|
      RiskFactorDefinition.score_for(
        risk_factor.category,
        risk_factor.identifier
      )
    end
  end

  def client_risk_score
    category_risk_score(:client_risk)
  end

  def products_and_services_risk_score
    category_risk_score(:products_and_services_risk)
  end

  def distribution_channel_risk_score
    category_risk_score(:distribution_channel_risk)
  end

  def transaction_risk_score
    category_risk_score(:transaction_risk)
  end

  def category_risk_score(category)
    RiskFactor.where(client: self, category: category).sum do |risk_factor|
      RiskFactorDefinition.score_for(
        category,
        risk_factor.identifier
      )
    end
  end

  def country_risk_score
    return Float::INFINITY if blacklisted?

    scores = []
    weights = []

    if country_of_residence.present?
      scores << CountryRiskScorer.calculate_risk_score(country_of_residence)
      weights << 40
    end

    if nationality.present?
      scores << CountryRiskScorer.calculate_risk_score(nationality)
      weights << 35
    end

    if country_of_profession.present?
      scores << CountryRiskScorer.calculate_risk_score(country_of_profession)
      weights << 15
    end

    if country_of_birth.present?
      scores << CountryRiskScorer.calculate_risk_score(country_of_birth)
      weights << 10
    end

    return 0 if scores.empty?

    weighted_sum = scores.zip(weights).sum { |score, weight| score.to_f * weight }
    (weighted_sum / weights.sum).round
  end

  def has_adverse_media?
    adverse_media_checks.any?(&:adverse_media_found?)
  end

  def pep?
    clientable.pep
  end

  def latest_risk_scoresheet
    risk_scoresheets.current
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
