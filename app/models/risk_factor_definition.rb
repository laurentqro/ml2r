class RiskFactorDefinition < ApplicationRecord
  CATEGORIES = [
    "client_risk",
    "products_and_services_risk",
    "distribution_channel_risk",
    "transaction_risk"
  ].freeze

  has_many :risk_factors

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :description, presence: true
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :description, uniqueness: { scope: [ :entity_type, :category ], message: "must be unique within the same type (person or company) and category (client_risk, products_and_services_risk, distribution_channel_risk, transaction_risk)" }

  scope :for_category, ->(category) { where(category: category) }
  scope :for_entity_type, ->(entity_type) { where(entity_type: entity_type) }

  def self.format_category_name(category)
    return "" if category.blank?

    category.humanize.titleize
  end

  def self.categories
    CATEGORIES
  end
end
