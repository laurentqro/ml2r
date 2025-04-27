module MatchesHelper
  def topic_badge_classes(topic)
    case topic
    when "sanction"
      "badge badge-error"
    when "wanted"
      "badge badge-error"
    when "corp.disqual"
      "badge badge-error"
    when "pep"
      "badge badge-warning"
    else
      "badge badge-outline"
    end
  end
end
