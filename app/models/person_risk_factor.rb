class PersonRiskFactor < RiskFactor
  enum :category, [ :business_relationship, :behavioral, :professional ]

  scope :business_relationship_risks, -> { where(category: :business_relationship) }
  scope :behavioral_risks, -> { where(category: :behavioral) }
  scope :professional_risks, -> { where(category: :professional) }

  DESCRIPTIONS = {
    business_relationship: {
      not_identified_personally: "The person has not been identified personally",
      remote_relationship: "Remote business relationship",
      non_eu_intermediary: "Non-EU intermediary",
      unregulated_intermediary: "Unregulated intermediary",
      short_time_introducer: "Short-time introducer"
    },
    behavioral: {
      rushed_transactions: "Rushed transactions",
      disproportionate_funds: "Disproportionate funds",
      avoids_meetings: "Avoids meetings",
      unusual_credit_terms: "Unusual credit terms"
    },
    professional: {
      precious_stones_dealer: "Precious stones dealer",
      antiques_art_dealer: "Antiques/artwork dealer",
      sensitive_materials_trader: "Sensitive materials trader (oil, raw materials, arms)",
      construction_influence: "Influence in construction/public works",
      gaming_establishment_owner: "Casino/gaming establishment owners",
      cash_intensive_business: "Cash-intensive business"
    }
  }

  def self.identifiers_for(category)
    DESCRIPTIONS[category.to_sym].keys
  end

  def description
    DESCRIPTIONS[category.to_sym][identifier.to_sym]
  end
end
