module ScreeningsHelper
  include MatchesHelper

  def topic_description(topic)
    find_topic_info(topic)["label"]
  end

  private

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
end
