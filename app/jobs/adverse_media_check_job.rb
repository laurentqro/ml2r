class AdverseMediaCheckJob < ApplicationJob
  queue_as :default

  def perform(client_id)
    client = Client.find(client_id)
    result = AdverseMediaCheckService.new(client.display_name).call

    AdverseMediaCheck.create(client_id: client_id) do |check|
      check.adverse_media_found = result[:adverse_media_found]
      check.status = result[:status]
      check.result = result
    end
  rescue StandardError => e
    AdverseMediaCheck.create(client_id: client_id) do |check|
      check.adverse_media_found = false
      check.status = "failed"
      check.result = e.message
    end
    raise
  end
end
