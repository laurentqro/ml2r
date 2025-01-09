class CreateScreenings < ActiveRecord::Migration[8.0]
  def change
    create_table :screenings do |t|
      t.integer :screenable_id
      t.string :screenable_type
      t.string :query

      t.timestamps
    end

    add_index :screenings, [:screenable_id, :screenable_type]
  end
end
