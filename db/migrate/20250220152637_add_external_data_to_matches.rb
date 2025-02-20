class AddExternalDataToMatches < ActiveRecord::Migration[8.0]
  def change
    add_column :matches, :external_data, :jsonb
    remove_column :matches, :measure_id, :integer
    add_index :matches, :external_data, using: :gin
  end
end
