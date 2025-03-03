class AdverseMediaCheck < ApplicationRecord
  belongs_to :client

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  def content_items
    result.dig("result", "choices", 0, "message", "content").split("\n")
  end

  def citations
    result.dig("result", "citations")
  end

  def adverse_media_status
    if completed?
      citations.present? ? "Adverse Media Found" : "No Adverse Media Found"
    else
      "Pending"
    end
  end
end
