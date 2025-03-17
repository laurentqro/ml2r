class AdverseMediaCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = AdverseMediaCheck.find(check_id)
    result = AdverseMediaCheckService.new(check.adverse_media_checkable.display_name).call

    check.update!(
      status: result["status"],
      adverse_media_found: result["adverse_media_found"],
      result: result
    )
  rescue StandardError => e
    check.update!(status: "failed", result: e.message)
    Rails.logger.error("AdverseMediaCheckJob failed: #{e.message}")
    raise
  end
end
