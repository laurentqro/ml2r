class CreateCompanyRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :company_relationships do |t|
      t.references :company, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.integer :relationship_type, null: false
      t.decimal :ownership_percentage, precision: 5, scale: 2
      t.text :notes

      t.timestamps
    end

    add_index :company_relationships, [ :company_id, :person_id, :relationship_type ], unique: true, name: 'idx_company_relationships_unique'
  end
end
