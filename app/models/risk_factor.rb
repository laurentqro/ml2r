class RiskFactor < ApplicationRecord
  belongs_to :risk_assessment
  belongs_to :risk_factor_definition

  enum :category, [ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ]
  enum :entity_type, [ :person, :company ]

  validates :category, :entity_type, presence: true

  scope :for_people, -> { where(entity_type: :person) }
  scope :for_companies, -> { where(entity_type: :company) }

  scope :client_risks, -> { where(category: :client_risk) }
  scope :products_and_services_risks, -> { where(category: :products_and_services_risk) }
  scope :distribution_channel_risks, -> { where(category: :distribution_channel_risk) }
  scope :transaction_risks, -> { where(category: :transaction_risk) }

  def description
    risk_factor_definition.description
  end

  def active?
    persisted?
  end

  def score
    risk_factor_definition.score
  end
end
