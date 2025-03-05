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
            content: "Search the web for any negative news, scandals, lawsuits, or controversies associated with '#{@client_name}'. Provide a concise summary of findings, focusing on adverse media. If adverse media are found, state that explicitly at the beginning of your response with this exact notice in this exact format (this is very important): '[adverse media found]'. If no adverse media are found, state that explicitly at the beginning of your response with this exact notice in this exact format (this is very important): '[no adverse media found]."
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
      summary = result.dig("choices", 0, "message", "content").to_s

      {
        "status" => "completed",
        "adverse_media_found" => summary.include?("[adverse media found]"),
        "result" => result,
      }
    else
      {
        "status" => "failed",
        "result" => "API request failed with response code #{response.code}"
      }
    end
  end
end
