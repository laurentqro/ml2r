class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true

  has_many :screenings, as: :screenable
  has_many :risk_factors, dependent: :destroy
  has_many :person_risk_factors, dependent: :destroy
  has_many :company_risk_factors, dependent: :destroy
  has_many :risk_scoresheets, dependent: :destroy

  delegate :country_of_residence, :nationality, :country_of_profession,
           :country_of_birth, to: :clientable, allow_nil: true

  validate :no_blacklisted_countries

  accepts_nested_attributes_for :clientable
  accepts_nested_attributes_for :risk_factors, allow_destroy: true,
    reject_if: proc { |attributes| attributes["identified_at"].blank? }

  def risk_factor_class
    case clientable_type
    when "Person" then PersonRiskFactor
    when "Company" then CompanyRiskFactor
    else raise "Unknown clientable type: #{clientable_type}"
    end
  end

  def available_risk_categories
    risk_factor_class.categories.keys
  end

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
    return Float::INFINITY if blacklisted?

    country_risk_score + total_risk_factors_score
  end

  def total_risk_factors_score
    available_risk_categories.sum { |category| category_risk_score(category) }
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
    risk_factor_class.where(client: self, category: category).count * 25
  end

  def blacklisted?
    [ country_of_residence, nationality, country_of_profession, country_of_birth ].compact.any? do |country|
      ::CountryRiskScorer.gafi_status(country) == :black
    end
  end

  def build_clientable(type:)
    case type.downcase
    when "person"
      self.clientable = Person.new
    when "company"
      self.clientable = Company.new
    else
      raise ArgumentError, "Invalid clientable type: #{type}"
    end
  end

  def country_risk_score
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

  private

  def no_blacklisted_countries
    if blacklisted?
      errors.add(:base, "Cannot onboard clients with ties to GAFI blacklisted countries")
    end
  end
end
