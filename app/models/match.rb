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

  def last_change
    Time.parse(external_data["last_change"])
  end

  def last_seen
    Time.parse(external_data["last_seen"])
  end

  def first_seen
    Time.parse(external_data["first_seen"])
  end

  def aliases
    Array(properties["alias"]).sort
  end

  def weak_aliases
    Array(properties["weakAlias"]).sort
  end

  def first_name
    Array(properties["firstName"]).sort
  end

  def last_name
    Array(properties["lastName"]).sort
  end

  def father_name
    Array(properties["fatherName"]).sort
  end

  def second_name
    Array(properties["secondName"]).sort
  end

  def title
    Array(properties["title"]).sort
  end

  def name
    Array(properties["name"]).sort
  end

  def nationality
    Array(properties["nationality"]).map do |country_code|
      ISO3166::Country[country_code]&.common_name
    end
  end

  def citizenship
    Array(properties["citizenship"]).map do |country_code|
      ISO3166::Country[country_code]&.common_name
    end
  end

  def wikidata_id
    Array(properties["wikidataId"]).sort
  end

  def position
    Array(properties["position"]).sort
  end

  def education
    Array(properties["education"]).sort
  end

  def religion
    Array(properties["religion"]).sort
  end

  def source_url
    Array(properties["sourceUrl"]).map { |url| url.chomp("/") }
  end

  def birth_date
    Array(properties["birthDate"]).sort
  end

  def website
    Array(properties["website"]).map { |url| url.chomp("/") }
  end

  def address
    Array(properties["address"]).sort
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

  def country
    Array(properties["country"]).map do |country_code|
      ISO3166::Country[country_code]&.common_name
    end
  end

  def countries
    (Array(properties["citizenship"]) + Array(properties["country"])).uniq
  end

  def gender
    properties["gender"]
  end

  def birth_place
    Array(properties["birthPlace"]).sort
  end

  def birth_country
    Array(properties["birthCountry"]).sort
  end

  def birth_date
    Array(properties["birthDate"]).sort
  end

  def ethnicity
    Array(properties["ethnicity"]).sort
  end
end
