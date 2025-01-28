class ClientsController < ApplicationController
  include Pagination

  def index
    @clients = paginate(Client.all)
  end

  def show
    @client = Client.find(params[:id])
    @screening = Screening.new(screenable: @client)
  end
end
