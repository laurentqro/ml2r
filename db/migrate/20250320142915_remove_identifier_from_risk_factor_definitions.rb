class RemoveIdentifierFromRiskFactorDefinitions < ActiveRecord::Migration[8.0]
  def up
    remove_index :risk_factor_definitions, name: "idx_risk_factor_definitions_unique"
    add_index :risk_factor_definitions, [:risk_factor_type, :category],
              name: "idx_risk_factor_definitions_on_type_and_category"
    remove_column :risk_factor_definitions, :identifier
  end

  def down
    add_column :risk_factor_definitions, :identifier, :string, null: false, default: ""
    remove_index :risk_factor_definitions, name: "idx_risk_factor_definitions_on_type_and_category"
    add_index :risk_factor_definitions, [:risk_factor_type, :category, :identifier],
              unique: true, name: "idx_risk_factor_definitions_unique"
    change_column_default :risk_factor_definitions, :identifier, nil
  end
end
