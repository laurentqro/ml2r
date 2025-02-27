class CreateRiskFactorDefinitions < ActiveRecord::Migration[8.0]
  def change
    create_table :risk_factor_definitions do |t|
      t.string :category, null: false
      t.text :description, null: false
      t.integer :score, null: false
      t.string :risk_factor_type, null: false
      t.string :identifier, null: false

      t.timestamps
    end

    add_index :risk_factor_definitions, [ :risk_factor_type, :category, :identifier ], unique: true, name: 'idx_risk_factor_definitions_unique'
  end
end
