class PersonRiskFactor < RiskFactor
  enum :category, [ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ]

  scope :client_risks, -> { where(category: :client_risk) }
  scope :products_and_services_risks, -> { where(category: :products_and_services_risk) }
  scope :distribution_channel_risks, -> { where(category: :distribution_channel_risk) }
  scope :transaction_risks, -> { where(category: :transaction_risk) }

  def self.identifiers_for(category)
    RiskFactorDefinition.where(risk_factor_type: name, category: category).pluck(:identifier).map(&:to_sym)
  end

  def description
    RiskFactorDefinition.description_for(self.class.name, category, identifier)
  end

  def self.available_categories
    categories.keys
  end

  def self.score_for(category, identifier)
    RiskFactorDefinition.score_for(name, category, identifier) || 0
  end
end
