class Sanction < ApplicationRecord
  scope :individuals, -> { where(nature: "Personne physique") }

  scope :companies, -> { where(nature: "Personne morale")
      .where('last_name LIKE ? OR last_name LIKE ?', "%LLC%", "%Ltd%") }
end
