class YenteClient
  BASE_URL = "https://yente.ml2r.app"

  def self.match(entity)
    response = connection.post("/match/default", {
      queries: {
        "entity1" => entity_to_query(entity)
      }
    })
    response.body
  rescue Faraday::Error => e
    Rails.logger.error "Yente API error: #{e.message}"
    { "matches" => [] }
  end

  private

  def self.connection
    Faraday.new(url: BASE_URL) do |f|
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
    end
  end

  def self.entity_to_query(entity)
    case entity
    when Person
      {
        id: entity.id.to_s,
        schema: "Person",
        properties: {
          name: ["#{entity.first_name} #{entity.last_name}"],
          birthDate: [entity.date_of_birth].compact,
          nationality: [entity.nationality].compact,
          country: [entity.country_of_residence].compact
        }.compact
      }
    when Company
      {
        id: entity.id.to_s,
        schema: "Organization",
        properties: {
          name: [entity.name].compact,
          jurisdiction: [entity.country].compact
        }.compact
      }
    else
      raise ArgumentError, "Unsupported entity type: #{entity.class}"
    end
  end
end 