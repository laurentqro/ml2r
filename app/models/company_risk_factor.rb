class CompanyRiskFactor < RiskFactor
  enum :category, [ :financing, :behavioral, :activity ]

  scope :financing_risks, -> { where(category: :financing) }
  scope :behavioral_risks, -> { where(category: :behavioral) }
  scope :activity_risks, -> { where(category: :activity) }

  def self.identifiers_for(category)
    case category.to_sym
    when :financing
      %w[
        financed_by_beneficial_owners
        financed_by_parent_company
        financed_by_settlor
        publicly_traded
      ]
    when :behavioral
      %w[
        subject_of_legal_proceedings
        corruption_risk
        cheque_deposits
      ]
    when :activity
      %w[
        government_related
        holding_company
        charity_trust
        construction_related
        cash_intensive
        virtual_assets
        offshore_business
        complex_structure
        shell_company
        high_risk_jurisdiction
      ]
    end
  end

  def description
    I18n.t("risk_factors.company.#{category}.#{identifier}")
  end
end
