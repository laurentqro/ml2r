class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true
  has_many :screenings, as: :screenable

  delegate :country_of_residence, :nationality, :country_of_profession,
           :country_of_birth, to: :clientable, allow_nil: true

  validate :no_blacklisted_countries

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

  def risk_score
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

  accepts_nested_attributes_for :clientable

  private

  def no_blacklisted_countries
    if blacklisted?
      errors.add(:base, "Cannot onboard clients with ties to GAFI blacklisted countries")
    end
  end
end
