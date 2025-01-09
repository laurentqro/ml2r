class Screening < ApplicationRecord
  belongs_to :screenable, polymorphic: true
  has_many :matches, dependent: :destroy
end
