class AdverseMediaChecksController < ApplicationController
  def new
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    AdverseMediaCheckJob.perform_later(@client.id)

    redirect_to client_path(@client), notice: "Adverse media check started"
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
