class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def show
    @client = Client.find(params[:id])
    @screening = Screening.new(screenable: @client)
  end
end
