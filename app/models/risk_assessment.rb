class RiskAssessment < ApplicationRecord
  belongs_to :client
  has_many :risk_factors, dependent: :destroy

  validates :status, presence: true

  enum :status, [ :pending, :completed, :approved, :rejected ]

  scope :current, -> { order(created_at: :desc).first }
  scope :approved, -> { where.not(approved_at: nil) }
  scope :pending_approval, -> { where(status: :completed, approved_at: nil) }

  accepts_nested_attributes_for :risk_factors, allow_destroy: true

  def approved?
    approved_at.present?
  end

  def completed?
    completed_at.present?
  end

  def approve!(approver_name)
    update!(
      status: :approved,
      approved_at: Time.current,
      approver_name: approver_name
    )
  end

  def reject!(notes = nil)
    update!(
      status: :rejected,
      notes: notes
    )
  end

  def complete!
    update!(
      status: :completed,
      completed_at: Time.current
    )
  end

  def total_risk_score
    risk_factors.sum do |risk_factor|
      risk_factor.risk_factor_definition.score
    end
  end
end 