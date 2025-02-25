class MatchesController < ApplicationController
  def index
    @client = Client.find(params[:client_id])
    @screening = @client.clientable.screenings.find(params[:screening_id])
    @matches = @screening.matches.order(score: :desc)
  end

  def show
    @client = Client.find(params[:client_id])
    @screening = @client.clientable.screenings.find(params[:screening_id])
    @match = @screening.matches.find(params[:id])
  end
end
