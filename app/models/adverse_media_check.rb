class AdverseMediaCheck < ApplicationRecord
  belongs_to :adverse_media_checkable, polymorphic: true

  after_commit :broadcast_status

  def broadcast_status
    Turbo::StreamsChannel.broadcast_replace_to(
      "adverse_media_check_#{id}_updates",
      target: "adverse_media_check_#{id}",
      partial: "adverse_media_checks/adverse_media_check",
      locals: { adverse_media_check: self }
    )
  end

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  def in_progress?
    status == "in progress"
  end

  def content_items
    result.dig("result", "choices", 0, "message", "content").split("\n")
  end

  def citations
    result.dig("result", "citations")
  end

  def adverse_media_status
    if completed?
      adverse_media_found? ? "Adverse Media Found" : "No Adverse Media Found"
    else
      "Pending"
    end
  end
end
