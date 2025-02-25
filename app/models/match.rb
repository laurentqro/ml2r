class Match < ApplicationRecord
  belongs_to :screening

  def properties
    external_data&.dig("properties") || {}
  end

  def schema
    external_data&.dig("schema")
  end

  def caption
    external_data&.dig("caption")
  end

  def aliases
    properties["alias"] || []
  end

  def nationality
    properties["nationality"]
  end

  def birth_date
    properties["birthDate"]
  end

  def address
    properties["address"]
  end

  def sanctions
    external_data&.dig("datasets") || []
  end

  def topics
    properties["topics"] || []
  end

  def external_score
    (external_data&.dig("score") * 100).to_i
  end

  def countries
    (Array(properties["citizenship"]) + Array(properties["country"])).uniq
  end
end
