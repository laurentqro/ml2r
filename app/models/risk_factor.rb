class RiskFactor < ApplicationRecord
  belongs_to :client

  # Include all possible categories from both person and company risk factors
  enum :category, [
    :business_relationship,
    :behavioral,
    :professional,
    :financing,
    :activity
  ]

  validates :identifier, presence: true
  validates :category, presence: true

  scope :business_relationship_risks, -> { where(category: :business_relationship) }
  scope :behavioral_risks, -> { where(category: :behavioral) }
  scope :professional_risks, -> { where(category: :professional) }

  def active?
    persisted?
  end

  private

  def risk_factor_type
    self.class.name.sub("RiskFactor", "").downcase.pluralize
  end
end
