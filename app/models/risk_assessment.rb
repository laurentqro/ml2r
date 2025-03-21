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
    calculate_and_save_scores!

    update!(
      status: :completed,
      completed_at: Time.current
    )
  end

  def calculate_and_save_scores!
    update!(
      client_risk_score: calculate_client_risk_score,
      products_and_services_risk_score: calculate_products_and_services_risk_score,
      distribution_channel_risk_score: calculate_distribution_channel_risk_score,
      transaction_risk_score: calculate_transaction_risk_score,
      country_risk_score: calculate_country_risk_score
    )
  end

  def calculate_client_risk_score
    risk_factors.client_risks.sum(&:score)
  end

  def calculate_products_and_services_risk_score
    risk_factors.products_and_services_risks.sum(&:score)
  end

  def calculate_distribution_channel_risk_score
    risk_factors.distribution_channel_risks.sum(&:score)
  end

  def calculate_transaction_risk_score
    risk_factors.transaction_risks.sum(&:score)
  end

  def calculate_country_risk_score
    return Float::INFINITY if blacklisted?

    scores = []
    weights = []

    if client.country_of_residence.present?
      scores << CountryRiskScorer.calculate_risk_score(client.country_of_residence)
      weights << 40
    end

    if client.nationality.present?
      scores << CountryRiskScorer.calculate_risk_score(client.nationality)
      weights << 35
    end

    if client.country_of_profession.present?
      scores << CountryRiskScorer.calculate_risk_score(client.country_of_profession)
      weights << 15
    end

    if client.country_of_birth.present?
      scores << CountryRiskScorer.calculate_risk_score(client.country_of_birth)
      weights << 10
    end

    return 0 if scores.empty?

    weighted_sum = scores.zip(weights).sum { |score, weight| score.to_f * weight }
    (weighted_sum / weights.sum).round
  end

  def total_risk_score
    if all_scores_present?
      country_risk_score +
      client_risk_score +
      products_and_services_risk_score +
      distribution_channel_risk_score +
      transaction_risk_score
    else
      calculate_country_risk_score +
      calculate_client_risk_score +
      calculate_products_and_services_risk_score +
      calculate_distribution_channel_risk_score +
      calculate_transaction_risk_score
    end
  end

  private

  def blacklisted?
    [
      client.country_of_residence,
      client.nationality,
      client.country_of_profession,
      client.country_of_birth
    ].compact.any? do |country|
      ::CountryRiskScorer.blacklisted?(country)
    end
  end

  def all_scores_present?
    [
      country_risk_score,
      client_risk_score,
      products_and_services_risk_score,
      distribution_channel_risk_score,
      transaction_risk_score
    ].all?(&:present?)
  end
end