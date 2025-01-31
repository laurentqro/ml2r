class CreateRiskFactors < ActiveRecord::Migration[8.0]
  def change
    create_table :risk_factors do |t|
      t.references :person, null: false, foreign_key: true
      t.integer :category
      t.string :identifier
      t.datetime :identified_at
      t.text :notes

      t.timestamps
    end

    add_index :risk_factors, [ :person_id, :category, :identifier ], unique: true
  end
end
