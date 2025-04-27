class AddAdverseMediaConfirmedToRiskAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :risk_assessments, :adverse_media_confirmed, :boolean
  end
end
