class RiskAssessmentsController < ApplicationController
  before_action :set_risk_assessment, only: %i[ show edit update destroy approve ]
  before_action :set_client

  def show
  end

  def new
    @risk_assessment = @client.risk_assessments.build
  end

  def edit
  end

  def create
    @risk_assessment = @client.risk_assessments.build(risk_assessment_params)

    respond_to do |format|
      if @risk_assessment.save
        @risk_assessment.calculate_and_save_scores!

        format.html { redirect_to [ @client, @risk_assessment ], notice: "Risk assessment was successfully created." }
        format.json { render :show, status: :created, location: @risk_assessment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @risk_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @risk_assessment.update(risk_assessment_params)
        @risk_assessment.calculate_and_save_scores!
        format.html { redirect_to [ @client, @risk_assessment ], notice: "Risk assessment was successfully updated." }
        format.json { render :show, status: :ok, location: @risk_assessment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @risk_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @risk_assessment.destroy!

    respond_to do |format|
      format.html { redirect_to risk_assessments_path, status: :see_other, notice: "Risk assessment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def approve
    @risk_assessment.approve!
    redirect_to [ @client, @risk_assessment ], notice: "Risk assessment approved."
  end

  private

    def set_risk_assessment
      @risk_assessment = RiskAssessment.find(params[:id])
    end

    def set_client
      @client = Client.find(params[:client_id])
    end

    def risk_assessment_params
      params.require(:risk_assessment).permit(
        :notes,
        :pep_confirmed,
        :adverse_media_confirmed,
        risk_factors_attributes: [
          :id,
          :risk_factor_definition_id,
          :category,
          :entity_type,
          :notes,
          :identified_at,
          :_destroy
        ]
      )
    end
end
