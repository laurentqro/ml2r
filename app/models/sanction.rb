class Sanction < ApplicationRecord
  scope :individuals, -> { where(nature: "Personne physique") }

  scope :companies, -> { where(nature: "Personne morale") }
end
