class RenameRiskFactorTypeToEntityType < ActiveRecord::Migration[8.0]
  def change
    rename_column :risk_factor_definitions, :risk_factor_type, :entity_type
  end
end
