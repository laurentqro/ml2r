require "httparty"

class AdverseMediaCheckService
  include HTTParty
  base_uri "https://api.perplexity.ai"

  def initialize(client_name)
    @client_name = client_name
    @api_key = Rails.application.credentials.perplexity_api_key
  end

  def call
    parse_response(query_perplexity_api)
  rescue StandardError => e
    {
      status: "failed",
      result: "Error checking adverse media: #{e.message}"
    }
  end

  private

  def query_perplexity_api
    self.class.post(
      "/chat/completions",
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      },
      body: {
        model: "sonar-pro",
        messages: [
          {
            role: "system",
            content: "Search the web for any negative news, scandals, lawsuits, or controversies associated with '#{@client_name}'. Provide a concise summary of findings, focusing on adverse media. If none are found, state that explicitly. If some adverse media are found, provide a list of the sources and the content of the adverse media, and clearly state 'no adverse media found' if none are found."
          },
          {
            role: "user",
            content: "Check for adverse media about #{@client_name}."
          }
        ],
        return_citations: true
      }.to_json,
      timeout: 60
    )
  end

  def parse_response(response)
    if response.success?
      result = JSON.parse(response.body)
      {
        status: "completed",
        adverse_media_found: result["citations"].any?,
        result: result
      }
    else
      {
        status: "failed",
        result: "API request failed with response code #{response.code}"
      }
    end
  end
end
