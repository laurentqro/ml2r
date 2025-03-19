class Screening < ApplicationRecord
  belongs_to :screenable, polymorphic: true
  has_many :matches, dependent: :destroy

  def run
    results = YenteClient.match(screenable)

    results.dig("responses", "entity1", "results")
      .reject { |match_data| match_data["match"] == false }
      .each do |match_data|
      score = match_data["score"] * 100
      matches.create!(
        external_data: match_data,
        score: score
      )
    end
  end
end
