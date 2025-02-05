class CompanyRiskFactor < RiskFactor
  enum :category, [ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ]

  scope :client_risks, -> { where(category: :client_risk) }
  scope :products_and_services_risks, -> { where(category: :products_and_services_risk) }
  scope :distribution_channel_risks, -> { where(category: :distribution_channel_risk) }
  scope :transaction_risks, -> { where(category: :transaction_risk) }

  DESCRIPTIONS = {
    client_risk: {
      subject_of_legal_proceedings: "Subject of legal proceedings",
      corruption_risk: "Company operates in country with high risk of corruption",
      government_related: "Government or public sector related",
      holding_company: "Holding company",
      charity_trust: "Charity-oriented trust",
      construction_related: "Active in construction/public works",
      cash_intensive: "Cash-intensive business operations",
      complex_structure: "Complex business structure",
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
end
