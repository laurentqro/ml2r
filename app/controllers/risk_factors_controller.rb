class RiskFactorsController < ApplicationController
  before_action :set_client

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      # Update PEP status if present
      if risk_factors_params[:clientable]
        @client.clientable.update!(risk_factors_params[:clientable])
      end

      # First, deactivate all existing risk factors
      @client.risk_factors.update_all(identified_at: nil)

      # Then activate the selected ones
      if risk_factors_params[:risk_factors_attributes]
        risk_factors_params[:risk_factors_attributes].values.each do |risk_factor_params|
          next if risk_factor_params[:identified_at].blank?

          @client.risk_factors.create_or_find_by!(
            category: risk_factor_params[:category],
            identifier: risk_factor_params[:identifier]
          ).update!(identified_at: Time.current)
        end
      end
    end

    redirect_to @client, notice: "Risk factors were successfully updated."
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def risk_factors_params
    params.require(:risk_factors).permit(
      clientable: [ :pep ],
      risk_factors_attributes: [ :category, :identifier, :identified_at ]
    )
  end
end
