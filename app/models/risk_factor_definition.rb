class RiskFactorDefinition < ApplicationRecord
  RISK_FACTOR_TYPES = [ "PersonRiskFactor", "CompanyRiskFactor" ].freeze

  CATEGORIES = [
    "client_risk",
    "products_and_services_risk",
    "distribution_channel_risk",
    "transaction_risk"
  ].freeze

  validates :risk_factor_type, presence: true, inclusion: { in: RISK_FACTOR_TYPES }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :identifier, presence: true, format: { with: /\A[a-z_]+\z/, message: "must be in snake_case format" }
  validates :description, presence: true
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :identifier, uniqueness: { scope: [ :risk_factor_type, :category ], message: "must be unique within the same risk factor type and category" }

  scope :by_category, ->(category) { where(category: category) }

  def self.format_category_name(category)
    return "" if category.blank?

    category.humanize.titleize
  end

  def self.score_for(category, identifier)
    find_by(category: category, identifier: identifier)&.score
  end

  def self.description_for(category, identifier)
    find_by(category: category, identifier: identifier)&.description
  end

  def self.identifiers_for(category)
    where(category: category).pluck(:identifier).map(&:to_sym)
  end

  def self.categories
    CATEGORIES
  end
end
