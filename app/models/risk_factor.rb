class RiskFactor < ApplicationRecord
  belongs_to :client

  validates :identifier, presence: true
  validates :category, presence: true

  def active?
    persisted?
  end
end
