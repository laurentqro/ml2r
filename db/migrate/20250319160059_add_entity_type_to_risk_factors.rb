class AddEntityTypeToRiskFactors < ActiveRecord::Migration[8.0]
  def change
    add_column :risk_factors, :entity_type, :integer, default: 0, null: false
  end
end
