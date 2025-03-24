module ClientsHelper
  def risk_badge_class(score)
    case score
    when 0..40   then "bg-green-100 text-green-800"
    when 41..70  then "bg-yellow-100 text-yellow-800"
    when 71..100 then "bg-orange-100 text-orange-800"
    else "bg-red-100 text-red-800"
    end
  end

  def edit_clientable_path(clientable)
    if clientable.is_a?(Company)
      edit_company_path(clientable)
    elsif clientable.is_a?(Person)
      edit_person_path(clientable)
    end
  end

  def country_name(code)
    ISO3166::Country[code]&.iso_short_name || code
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    css_class = "#{column == sort_column ? 'text-blue-900' : 'text-gray-900'} w-full flex justify-center"

    # Keep all params except page
    preserved_params = request.params.except(:page).merge(sort: column, direction: direction)

    link_to clients_path(preserved_params), class: css_class do
      tag.div class: "flex gap-1" do
        concat title
      end
    end
  end

  def sort_column
    %w[
      risk_assessment_status
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
