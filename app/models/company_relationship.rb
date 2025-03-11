class CompanyRelationship < ApplicationRecord
  belongs_to :company
  belongs_to :person

  enum :relationship_type, {
    director: 0,
    beneficial_owner: 1,
    legal_representative: 2,
    significant_control: 3
  }

  validates :relationship_type, presence: true
  validates :ownership_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  validates :ownership_percentage, presence: true, if: -> { beneficial_owner? }

  scope :directors, -> { where(relationship_type: :director) }
  scope :beneficial_owners, -> { where(relationship_type: :beneficial_owner) }
  scope :legal_representatives, -> { where(relationship_type: :legal_representative) }
  scope :significant_controls, -> { where(relationship_type: :significant_control) }
end
