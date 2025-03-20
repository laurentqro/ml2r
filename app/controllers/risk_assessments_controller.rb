class RiskAssessmentsController < ApplicationController
  before_action :set_risk_assessment, only: %i[ show edit update destroy ]
  before_action :set_client

  def index
    @risk_assessments = RiskAssessment.all
  end

  def show
  end

  def new
    @risk_assessment = @client.risk_assessments.build

    RiskFactorDefinition.categories.each do |category|
      RiskFactorDefinition.by_category(category).each do |definition|
        @risk_assessment.risk_factors.build(risk_factor_definition: definition)
      end
    end
  end

  def edit
  end

  def create
    @risk_assessment = @client.risk_assessments.build(risk_assessment_params)

    respond_to do |format|
      if @risk_assessment.save
        format.html { redirect_to @client, notice: "Risk assessment was successfully created." }
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
        format.html { redirect_to @risk_assessment, notice: "Risk assessment was successfully updated." }
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

  private

    def set_risk_assessment
      @risk_assessment = RiskAssessment.find(params.expect(:id))
    end

    def set_client
      @client = Client.find(params.expect(:client_id))
    end

    def risk_assessment_params
      params.expect(
        risk_assessment: [
          :status,
          :notes,
          :approved_at,
          :approver_name,
          risk_factors_attributes: [
            :id,
            :risk_factor_definition_id,
            :notes,
            :identified_at
          ]
        ]
      )
    end
end
