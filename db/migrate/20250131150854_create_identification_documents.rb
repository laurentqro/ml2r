class CreateIdentificationDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :identification_documents do |t|
      t.references :person, null: false, foreign_key: true
      t.string :document_type, null: false
      t.string :number, null: false
      t.date :expiration_date, null: false
      t.boolean :is_copy, null: false, default: false

      t.timestamps
    end
  end
end
