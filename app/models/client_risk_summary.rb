class ClientRiskSummary < ApplicationRecord
  self.primary_key = "client_id"

  belongs_to :client

  scope :clear, -> { where(pep: nil, sanctioned: nil, adverse_media: nil) }
  scope :pep, -> { where(pep: true) }
  scope :sanctioned, -> { where(sanctioned: true) }
  scope :with_adverse_media, -> { where(adverse_media: true) }

  def readonly?
    true
  end
end
