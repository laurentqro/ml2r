class RiskScoresheet < ApplicationRecord
  belongs_to :client
  belongs_to :risk_assessment, optional: true

  validates_presence_of :client,
                        :country_risk_score,
                        :client_risk_score,
                        :products_and_services_risk_score,
                        :distribution_channel_risk_score,
                        :transaction_risk_score

  def self.current
    order(created_at: :desc).first
  end

  def self.create_for_assessment!(risk_assessment)
    client_risk_score                 = risk_assessment.risk_factors.client_risks.sum(&:score)
    products_and_services_risk_score  = risk_assessment.risk_factors.products_and_services_risks.sum(&:score)
    distribution_channel_risk_score   = risk_assessment.risk_factors.distribution_channel_risks.sum(&:score)
    transaction_risk_score            = risk_assessment.risk_factors.transaction_risks.sum(&:score)
    country_risk_score                = calculate_country_risk

    create!(
      client: client,
      risk_assessment: risk_assessment,
      country_risk_score: country_risk_score,
      client_risk_score: client_risk_score,
      products_and_services_risk_score: products_and_services_risk_score,
      distribution_channel_risk_score: distribution_channel_risk_score,
      transaction_risk_score: transaction_risk_score
    )
  end

  def total_risk_score
    country_risk_score + client_risk_score + products_and_services_risk_score + distribution_channel_risk_score + transaction_risk_score
  end

  private

  # TODO: Move this to the country risk scorer service
  def calculate_country_risk_score
    return Float::INFINITY if blacklisted?

    scores = []
    weights = []

    if client.country_of_residence.present?
      scores << CountryRiskScorer.calculate_risk_score(client.country_of_residence)
      weights << 40
    end

    if client.nationality.present?
      scores << CountryRiskScorer.calculate_risk_score(client.nationality)
      weights << 35
    end

    if client.country_of_profession.present?
      scores << CountryRiskScorer.calculate_risk_score(client.country_of_profession)
      weights << 15
    end

    if client.country_of_birth.present?
      scores << CountryRiskScorer.calculate_risk_score(client.country_of_birth)
      weights << 10
    end

    return 0 if scores.empty?

    weighted_sum = scores.zip(weights).sum { |score, weight| score.to_f * weight }
    (weighted_sum / weights.sum).round
  end

  def blacklisted?
    [ client.country_of_residence, client.nationality, client.country_of_profession, client.country_of_birth ].compact.any? do |country|
      ::CountryRiskScorer.gafi_status(country) == :black
    end
  end
end
