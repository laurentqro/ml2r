class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true
  has_many :screenings, as: :screenable

  delegate :country_of_residence, :nationality, :country_of_profession, 
           :country_of_birth, to: :clientable, allow_nil: true

  validate :no_blacklisted_countries

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
    [country_of_residence, nationality, country_of_profession, country_of_birth].compact.any? do |country|
      ::CountryRiskScorer.gafi_status(country) == :black
    end
  end

  private

  def no_blacklisted_countries
    if blacklisted?
      errors.add(:base, "Cannot onboard clients with ties to GAFI blacklisted countries")
    end
  end
end
