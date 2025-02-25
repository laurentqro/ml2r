class PersonRiskFactor < RiskFactor
  enum :category, [ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ]

  scope :client_risks, -> { where(category: :client_risk) }
  scope :products_and_services_risks, -> { where(category: :products_and_services_risk) }
  scope :distribution_channel_risks, -> { where(category: :distribution_channel_risk) }
  scope :transaction_risks, -> { where(category: :transaction_risk) }

  DESCRIPTIONS = {
    client_risk: {
      rushed_transactions: "Client wants to complete the transaction quickly for no apparent reason",
      trust_or_foundation: "Client is a trust or foundation",
      precious_stones_dealer: "Client is a precious stones dealer",
      antiques_art_dealer: "Client is an antiques/artwork dealer",
      sensitive_materials_trader: "Client is a sensitive materials trader (oil, raw materials, arms)",
      construction_influence: "Client has influence in construction/public works",
      gaming_establishment_owner: "Client is a casino or gaming establishment owner",
      cash_intensive_business: "Client is a cash-intensive business"
    },
    products_and_services_risk: {
      new_build_sale: "Client is selling or buying a new build property",
      existing_build_sale: "Client is selling or buying an existing build property",
      main_residence_rental_above_10_000_euros: "Client is renting their main residence for more than 10 000 euros",
      secondary_residence_rental_above_10_000_euros: "Client is renting their secondary residence for more than 10 000 euros"
    },
    distribution_channel_risk: {
      remote_relationship: "The relationship is remote",
      presence_of_intermediary: "An intermediary is involved"
    },
    transaction_risk: {
      means_of_payment: "The means of payment is unusual",
      transaction_amount: "The transaction amount is high",
      transaction_frequency: "The transaction frequency is high",
      fractioned_payments: "The payments are fractioned",
      complex_transactions: "The transactions are complex",
      manipulation_of_property_value: "The property value appears to be manipulated (over or under-valuation)"
    }
  }

  def self.identifiers_for(category)
    DESCRIPTIONS[category.to_sym].keys
  end

  def description
    DESCRIPTIONS[category.to_sym][identifier.to_sym]
  end

  def self.available_categories
    categories.keys
  end
end
