module ScreeningsHelper
  def match_score_classes(score)
    case score
    when 90..120 then "bg-green-100 text-green-800"  # Best match (most confident)
    when 70..89 then "bg-orange-100 text-orange-800" # High risk
    when 50..69 then "bg-yellow-100 text-yellow-800" # Medium risk
    else "bg-gray-100 text-gray-800"                 # Low confidence match
    end
  end
end
