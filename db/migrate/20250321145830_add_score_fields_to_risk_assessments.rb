class AddScoreFieldsToRiskAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :risk_assessments, :country_risk_score, :integer
    add_column :risk_assessments, :client_risk_score, :integer
    add_column :risk_assessments, :products_and_services_risk_score, :integer
    add_column :risk_assessments, :distribution_channel_risk_score, :integer
    add_column :risk_assessments, :transaction_risk_score, :integer
  end
end
