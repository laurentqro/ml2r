class AdverseMediaChecksController < ApplicationController
  def new
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @check = @client.adverse_media_checks.create!
    AdverseMediaCheckJob.perform_later(@check.id)

    respond_to do |format|
      format.html { redirect_to client_path(@client) }
      format.turbo_stream
    end
  end

  def check_status
    adverse_media_check = AdverseMediaCheck.find(params[:id])

    if adverse_media_check.completed?
      render json: { status: "completed", data: adverse_media_check.result }
    elsif adverse_media_check.failed?
      render json: { status: "failed", error: adverse_media_check.result }, status: :unprocessable_entity
    else
      render json: { status: "pending" }, status: :accepted
    end
  end
end
