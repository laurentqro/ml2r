class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true
  has_many :screenings, as: :screenable
end
