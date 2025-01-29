class Screening < ApplicationRecord
  include MatchScoring
  
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
    person = screenable
    Sanction.individuals
            .where("last_name LIKE ? OR first_name LIKE ? OR alias LIKE ?", 
                  "#{query}%", "#{query}%", "%#{query}%")
            .find_each do |sanction|
      score = calculate_person_match_score(person, sanction)
      matches.create!(measure_id: sanction.measure_id, score: score) if score > 0
    end
  end

  def screen_company
    company = screenable
    Sanction.companies
            .where("last_name LIKE ? OR alias LIKE ?", 
                  "#{query}%", "%#{query}%")
            .find_each do |sanction|
      score = calculate_company_match_score(company, sanction)
      matches.create!(measure_id: sanction.measure_id, score: score) if score > 0
    end
  end
end
