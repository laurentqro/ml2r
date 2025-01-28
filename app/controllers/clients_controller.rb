class ClientsController < ApplicationController
  include Pagination

  def index
    base_scope = Client.includes(:clientable)
    filtered_scope = base_scope.where(clientable_type: (params[:nature] || 'person').capitalize)
    @clients = paginate(filtered_scope)
  end

  def show
    @client = Client.find(params[:id])
    @screening = Screening.new(screenable: @client)
  end
end
