class ProspectsController < ApplicationController
  include Pagination
  include ProspectsHelper

  def index
    if params[:nature] == "company"
      scope = Company.where.missing(:business_relationships)

      if params[:query].present?
        search_term = "%#{params[:query].downcase}%"
        scope = scope.where("LOWER(name) LIKE ?", search_term)
      end
    else
      scope = Person.where.missing(:business_relationships)

      if params[:query].present?
        search_term = "%#{params[:query].downcase}%"
        scope = scope.where("LOWER(last_name) LIKE ?", search_term)
      end
    end

    @prospects = paginate(scope)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
