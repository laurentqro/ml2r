module ClientsHelper
  def risk_badge_class(score)
    case score
    when 0..40   then "bg-green-100 text-green-800"
    when 41..70  then "bg-yellow-100 text-yellow-800"
    when 71..100 then "bg-orange-100 text-orange-800"
    else "bg-red-100 text-red-800"
    end
  end

  def country_name(code)
    ISO3166::Country[code]&.iso_short_name || code
  end
end
