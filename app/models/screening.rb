class Screening < ApplicationRecord
  belongs_to :screenable, polymorphic: true
  has_many :matches, dependent: :destroy
  has_many :sanctions, -> { distinct }, through: :matches

  def run
    case screenable_type
    when "Person"
      screen_person
    when "Company"
      screen_company
    end
  end

  private

  def screen_person
    Sanction.individuals
            .where("last_name LIKE ?", "#{query}%")
            .find_each do |sanction|
      matches.create!(measure_id: sanction.measure_id)
    end
  end

  def screen_company
    Sanction.companies
            .where("last_name LIKE ?", "#{query}%")
            .find_each do |sanction|
      matches.create!(measure_id: sanction.measure_id)
    end
  end
end
