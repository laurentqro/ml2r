class ClientsController < ApplicationController
  include Pagination

  def index
    base_scope = Client.includes(:clientable)
                      .joins("LEFT JOIN people ON clients.clientable_id = people.id AND clients.clientable_type = 'Person'")
                      .joins("LEFT JOIN companies ON clients.clientable_id = companies.id AND clients.clientable_type = 'Company'")
                      .order(Arel.sql('COALESCE(people.last_name, companies.name) ASC'))
    filtered_scope = base_scope.where(clientable_type: (params[:nature] || 'person').capitalize)
    @clients = paginate(filtered_scope)
  end

  def show
    @client = Client.find(params[:id])
    @screening = Screening.new(screenable: @client)
  end
end
