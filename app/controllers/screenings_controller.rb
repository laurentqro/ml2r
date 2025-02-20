class ScreeningsController < ApplicationController
  def index
    @screenings = Screening.all
  end

  def show
    @client = Client.find(params[:client_id])
    @screening = Screening.includes(:matches).find(params[:id])
    @matches = @screening.matches.order(score: :desc)
  end

  def create
    @client = Client.find(params[:client_id])
    @screening = Screening.new(screening_params)

    if @screening.save
      @screening.run
      redirect_to @client
    else
      render :new
    end
  end

  private

  def screening_params
    params.expect(screening: [ :screenable_id, :screenable_type, :query ])
  end
end
