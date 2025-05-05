module Admin
  class RiskFactorDefinitionsController < ApplicationController
    before_action :set_risk_factor_definition, only: [ :edit, :update, :destroy ]

    def index
      @risk_factor_definitions = RiskFactorDefinition.all
        .order(:entity_type, :category, :description)
    end

    def new
      @risk_factor_definition = RiskFactorDefinition.new
    end

    def create
      @risk_factor_definition = RiskFactorDefinition.new(risk_factor_definition_params)

      if @risk_factor_definition.save
        redirect_to admin_risk_factor_definitions_path, notice: "Risk factor definition was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @risk_factor_definition.update(risk_factor_definition_params)
        redirect_to admin_risk_factor_definitions_path, notice: "Risk factor definition was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @risk_factor_definition.risk_factors.delete_all
      @risk_factor_definition.delete
      redirect_to admin_risk_factor_definitions_path, notice: "Risk factor definition was successfully deleted."
    end

    private

    def set_risk_factor_definition
      @risk_factor_definition = RiskFactorDefinition.find(params[:id])
    end

    def risk_factor_definition_params
      params.expect(risk_factor_definition: [
        :entity_type,
        :category,
        :identifier,
        :description,
        :score
      ])
    end
  end
end
