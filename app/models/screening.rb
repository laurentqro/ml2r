class Screening < ApplicationRecord
  belongs_to :screenable, polymorphic: true
  has_many :matches, dependent: :destroy

  def run
    Sanction.where("last_name LIKE ?", "#{self.query}%").each do |sanction|
      self.matches.create!(measure_id: sanction.measure_id)
    end
  end
end
