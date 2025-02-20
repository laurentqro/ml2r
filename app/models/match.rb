class Match < ApplicationRecord
  belongs_to :screening

  def properties
    external_data&.dig("properties") || {}
  end

  def schema
    external_data&.dig("schema")
  end

  def name
    if schema == "Person"
      "#{properties['lastName']}, #{properties['firstName']}".strip.chomp(",")
    else
      properties["name"]
    end
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

  def person?
    schema == "Person"
  end

  def company?
    schema == "Organization"
  end
end
