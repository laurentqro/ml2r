module ScreeningsHelper
  def match_score_classes(score)
    case score
    when 80..100 then "badge badge-success"
    when 60..79 then "badge badge-warning"
    when 50..59 then "badge badge-secondary"
    else "badge badge-ghost"
    end
  end

  def topic_badge_classes(topic)
    if is_risk_linked_topic?(topic)
      "badge badge-error"
    else
      "badge badge-info"
    end
  end

  def topic_priority(topic)
    if is_risk_linked_topic?(topic)
      1
    else
      2
    end
  end

  def topic_description(topic)
    find_topic_info(topic)["label"]
  end

  def all_topics
    @all_topics ||= begin
      topics_file = Rails.root.join("lib", "data", "topics.json")
      json_data = JSON.parse(File.read(topics_file))
      json_data["topics"].sort_by { |t| t["target"] }
    end
  end

  def find_topic_info(topic_code)
    all_topics.find { |t| t["code"] == topic_code }
  end

  def is_risk_linked_topic?(topic)
    topic_info = find_topic_info(topic)
    topic_info.present? && topic_info["target"] == "yes"
  end
end