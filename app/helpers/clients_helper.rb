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

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    css_class = column == sort_column ? "text-blue-600" : "text-gray-900"
    link_to clients_path(request.params.merge(sort: column, direction: direction)), class: css_class do
      tag.div class: "flex items-center gap-1" do
        concat title
        if column == sort_column
          concat tag.svg class: "h-4 w-4", fill: "currentColor", viewBox: "0 0 24 24" do
            if sort_direction == "asc"
              concat tag.path d: "M12 4l-8 8h16l-8-8z"
            else
              concat tag.path d: "M12 20l8-8H4l8 8z"
            end
          end
        end
      end
    end
  end

  def sort_column
    %w[
      display_name
      country_risk_score
      client_risk_score
      products_and_services_risk_score
      distribution_channel_risk_score
      transaction_risk_score
      total_risk_score
    ].include?(params[:sort]) ? params[:sort] : "display_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
