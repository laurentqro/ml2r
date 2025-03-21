class UpdateRiskFactorRelationships < ActiveRecord::Migration[8.0]
  def up
    add_reference :risk_factors, :risk_assessment, foreign_key: true
    add_reference :risk_factors, :risk_factor_definition, foreign_key: true

    remove_index :risk_factors, name: "index_risk_factors_on_client_id_and_category_and_identifier"
    add_index :risk_factors, [ :risk_assessment_id, :risk_factor_definition_id ], unique: true, name: "idx_risk_factors_on_risk_assessment_and_definition"
  end

  def down
    remove_index :risk_factors, name: "idx_risk_factors_on_risk_assessment_and_definition"
    add_index :risk_factors, [ :client_id, :category, :identifier ], unique: true

    remove_reference :risk_factors, :risk_factor_definition
    remove_reference :risk_factors, :risk_assessment
  end
end
