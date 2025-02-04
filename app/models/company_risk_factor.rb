class CompanyRiskFactor < RiskFactor
  enum :category, [ :financing, :behavioral, :activity ]

  scope :financing_risks, -> { where(category: :financing) }
  scope :behavioral_risks, -> { where(category: :behavioral) }
  scope :activity_risks, -> { where(category: :activity) }

  DESCRIPTIONS = {
    financing: {
      financed_by_beneficial_owners: "Financed by beneficial owners",
      financed_by_parent_company: "Financed by parent company",
      financed_by_settlor: "Financed by settlor",
      publicly_traded: "Publicly traded"
    },
    behavioral: {
      subject_of_legal_proceedings: "Subject of legal proceedings",
      corruption_risk: "Company operates in country with high risk of corruption",
      cheque_deposits: "Cheque deposits"
    },
    activity: {
      government_related: "Government or public sector related",
      holding_company: "Holding company",
      charity_trust: "Charity-oriented trust",
      construction_related: "Active in construction/public works",
      cash_intensive: "Cash-intensive business operations",
      virtual_assets: "Virtual asset service provider",
      offshore_business: "Offshore business activities",
      complex_structure: "Complex business structure",
      shell_company: "Shell company characteristics",
      high_risk_jurisdiction: "Operations in high-risk jurisdictions"
    }
  }

  def self.identifiers_for(category)
    DESCRIPTIONS[category.to_sym].keys
  end

  def description
    DESCRIPTIONS[category.to_sym][identifier.to_sym]
  end
end
