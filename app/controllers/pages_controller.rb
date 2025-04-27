class PagesController < ApplicationController
  def dashboard
    # Risk matrices
    @client_risk_matrix = RiskMatrixCalculator.calculate(:client_risk_score)
    @products_risk_matrix = RiskMatrixCalculator.calculate(:products_and_services_risk_score)
    @distribution_risk_matrix = RiskMatrixCalculator.calculate(:distribution_channel_risk_score)
    @transaction_risk_matrix = RiskMatrixCalculator.calculate(:transaction_risk_score)
    @country_risk_matrix = RiskMatrixCalculator.calculate(:country_risk_score)
    @total_risk_matrix = RiskMatrixCalculator.calculate(:total_risk_score)

    # Client statistics
    @clear_count = ClientRiskSummary.clear.count
    @pep_count = ClientRiskSummary.pep.count
    @sanctioned_count = ClientRiskSummary.sanctioned.count
    @with_adverse_media_count = ClientRiskSummary.with_adverse_media.count
  end
end
