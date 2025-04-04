module ClientsHelper
  def risk_badge_class(score)
    case score
    when 0..40   then "bg-green-100 text-green-800"
    when 41..70  then "bg-yellow-100 text-yellow-800"
    when 71..100 then "bg-orange-100 text-orange-800"
    else "bg-red-100 text-red-800"
    end
  end

  # Helper method to render risk score cell
  def render_risk_score_cell(score)
    if score
      badge_class = risk_badge_class(score)
      bg_class = case badge_class
      when "bg-green-100 text-green-800" then "bg-success/10"
      when "bg-yellow-100 text-yellow-800" then "bg-warning/10"
      when "bg-orange-100 text-orange-800", "bg-red-100 text-red-800" then "bg-error/10"
      else "bg-base-200"
      end
      text_class = case badge_class
      when "bg-green-100 text-green-800" then "text-success"
      when "bg-yellow-100 text-yellow-800" then "text-warning"
      when "bg-orange-100 text-orange-800", "bg-red-100 text-red-800" then "text-error"
      else "text-base-content"
      end

      content_tag(:div, class: "flex justify-center") do
        content_tag(:div, score, class: "#{bg_class} #{text_class} w-8 h-8 rounded-full flex items-center justify-center font-medium")
      end
    else
      content_tag(:span, "-", class: "text-base-content/40")
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
    css_class = "#{column == sort_column ? 'text-base-content' : 'text-base-content/50'} w-full flex justify-center"

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
