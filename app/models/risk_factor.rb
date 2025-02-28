class RiskFactor < ApplicationRecord
  belongs_to :client
  enum :category, [ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ]

  validates :identifier, presence: true
  validates :category, presence: true

  def active?
    persisted?
  end
end
