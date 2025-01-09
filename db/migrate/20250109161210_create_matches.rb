class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.integer :measure_id
      t.references :screening, null: false, foreign_key: true

      t.timestamps
    end
  end
end
