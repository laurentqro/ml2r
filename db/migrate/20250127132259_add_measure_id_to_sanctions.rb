class AddMeasureIdToSanctions < ActiveRecord::Migration[8.0]
  def change
    add_column :sanctions, :measure_id, :integer
    add_index :sanctions, :measure_id
  end
end
