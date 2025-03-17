class MatchesController < ApplicationController
  def index
    @screening = Screening.find(params[:screening_id])
    @matches = @screening.matches.order(score: :desc)
  end

  def show
    @screening = Screening.find(params[:screening_id])
    @match = @screening.matches.find(params[:id])
  end
end
