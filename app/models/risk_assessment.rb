class RiskAssessment < ApplicationRecord
  belongs_to :client
  has_many :risk_factors, dependent: :destroy

  default_scope { order(created_at: :desc) }

  scope :current, -> { order(created_at: :desc).first }
  scope :approved, -> { where.not(approved_at: nil) }
  scope :latest_approved, -> { approved.order(approved_at: :desc).first }
  scope :pending_approval, -> { where.not(created_at: nil).where(approved_at: nil) }

  accepts_nested_attributes_for :risk_factors,
                               allow_destroy: true,
                               reject_if: proc { |attributes| attributes["identified_at"].blank? },
                               update_only: true

  def approve!
    update!(approved_at: Time.current)
  end

  def approved?
    approved_at.present?
  end

  def superseded?
    !approved? && !latest?
  end

  def eligible_for_review?
    latest? && !approved?
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
    return 100 if pep_confirmed? || adverse_media_confirmed?

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

  def risk_level
    return "high" if pep_confirmed? || adverse_media_confirmed?

    case total_risk_score
    when 0..30
      "low"
    when 31..60
      "medium"
    else
      "high"
    end
  end

  def due_diligence_level
    return "enhanced" if pep_confirmed? || adverse_media_confirmed?

    case risk_level
    when "low"
      "simplified"
    when "medium"
      "standard"
    when "high"
      "enhanced"
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

  def latest?
    client.risk_assessments.current == self
  end
end
