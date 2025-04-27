class AddPepConfirmedToRiskAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :risk_assessments, :pep_confirmed, :boolean
  end
end
