class RiskFactor < ApplicationRecord
  belongs_to :person

  enum :category, [ :business_relationship, :behavioral, :professional ]

  validates :identifier, presence: true, uniqueness: { scope: [ :person_id, :category ] }
  validates :category, presence: true

  scope :business_relationship_risks, -> { where(category: :business_relationship) }
  scope :behavioral_risks, -> { where(category: :behavioral) }
  scope :professional_risks, -> { where(category: :professional) }
  scope :active, -> { where.not(identified_at: nil) }

  def self.identifiers_for(category)
    case category.to_sym
    when :business_relationship
      %w[
        not_identified_personally
        remote_relationship
        unreasonable_choice
        private_bank_relationship
        single_transaction
        online_relationship
        remote_relationship_no_guarantees
        non_eu_intermediary
        unregulated_intermediary
        dubious_intermediary
        insufficient_cdd
        via_introducer
        short_time_introducer
        unregulated_introducer
      ]
    when :behavioral
      %w[
        company_accounts_personal_use
        negative_legal_proceedings
        complex_structure
        questionable_activities
        frequent_cash_operations
        check_deposits
        unexplained_transfers
        little_direct_contact
        bribe_risk
        tax_non_compliance
        criminal_history
        third_party_instructions
        masks_understanding
        unexplained_modifications
        unusual_circumstances
        emerging_markets
        disproportionate_funds
        multiple_addresses
        virtual_assets
        high_fees
        insufficient_info
        falsification
        inconsistent_factors
        last_minute_changes
        rushed_transactions
        residency_seeking
        illegitimate_profit
        headquarters_transfer
        inadequate_aml
        avoids_meetings
        unclear_activities
        frequent_legal_changes
        frequent_advisor_changes
        avoids_approvals
        unexplained_ownership
        unknown_instructions
        nonprofit_no_purpose
        unusual_cash_fees
        unknown_third_parties
        obscured_ownership
        sudden_activity
        unusual_employee_ratio
        high_turnover
        complex_ownership
        high_asset_levels
        liquidating_businesses
        insufficient_consideration
        unusual_credit_terms
        delayed_payments
        beyond_expertise
        new_technologies
        hard_value_assets
        rapid_transfers
        no_legitimate_purpose
        fraudulent_transactions
        intercompany_transfers
        unusual_representation
        anonymity_products
        concealing_ownership
        anonymity_services
      ]
    when :professional
      %w[
        retiree
        self_employed
        transport
        precious_stones
        antiques_art
        sensitive_materials
        construction
        financial_traders
        gaming
        sports_entertainment
        union_leaders
        charities
        cash_intensive
      ]
    end
  end

  def description
    I18n.t("risk_factors.#{category}.#{identifier}")
  end

  def active?
    identified_at.present?
  end
end
