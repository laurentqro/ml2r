class RiskScoresheet < ApplicationRecord
  belongs_to :client

  validates_presence_of :client, :country_risk_score, :client_risk_score, :products_and_services_risk_score, :distribution_channel_risk_score, :transaction_risk_score

  scope :current, -> { order(created_at: :asc).last }

  def self.create_for_client!(client)
    create!(
      client: client,
      country_risk_score: client.country_risk_score,
      client_risk_score: client.client_risk_score,
      products_and_services_risk_score: client.products_and_services_risk_score,
      distribution_channel_risk_score: client.distribution_channel_risk_score,
      transaction_risk_score: client.transaction_risk_score
    )
  end

  def total_risk_score
    country_risk_score + client_risk_score + products_and_services_risk_score + distribution_channel_risk_score + transaction_risk_score
  end
end
