class AddRiskAssessmentToRiskScoresheets < ActiveRecord::Migration[8.0]
  def change
    add_reference :risk_scoresheets, :risk_assessment, null: false, foreign_key: true
  end
end
