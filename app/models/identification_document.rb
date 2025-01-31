class IdentificationDocument < ApplicationRecord
  belongs_to :person

  validates :document_type, :number, :expiration_date, presence: true
  validate :expiration_date_cannot_be_in_past

  private

  def expiration_date_cannot_be_in_past
    if expiration_date.present? && expiration_date < Date.current
      errors.add(:expiration_date, "can't be in the past")
    end
  end
end
