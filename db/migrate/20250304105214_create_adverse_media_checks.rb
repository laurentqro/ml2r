class CreateAdverseMediaChecks < ActiveRecord::Migration[8.0]
  def change
    create_table :adverse_media_checks do |t|
      t.references :client, null: false, foreign_key: true
      t.string :status
      t.boolean :adverse_media_found
      t.json :result
      t.timestamps
    end
  end
end
