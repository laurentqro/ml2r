class RiskFactor < ApplicationRecord
  belongs_to :client

  enum :category, [ :business_relationship, :behavioral, :professional ]

  validates :identifier, presence: true, uniqueness: { scope: [ :client_id, :category ] }
  validates :category, presence: true

  scope :business_relationship_risks, -> { where(category: :business_relationship) }
  scope :behavioral_risks, -> { where(category: :behavioral) }
  scope :professional_risks, -> { where(category: :professional) }

  def self.identifiers_for(category)
    case category.to_sym
    when :business_relationship
      %w[
        not_identified_personally
        remote_relationship
        non_eu_intermediary
        unregulated_intermediary
        short_time_introducer
      ]
    when :behavioral
      %w[
        rushed_transactions
        disproportionate_funds
        avoids_meetings
        unusual_credit_terms
      ]
    when :professional
      %w[
        precious_stones_dealer
        antiques_art_dealer
        sensitive_materials_trader
        construction_influence
        gaming_establishment_owner
      ]
    end
  end

  def description
    I18n.t("risk_factors.#{category}.#{identifier}")
  end

  def active?
    persisted?
  end
end
