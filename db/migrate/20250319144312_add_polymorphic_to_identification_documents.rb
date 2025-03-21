class AddPolymorphicToIdentificationDocuments < ActiveRecord::Migration[8.0]
  def change
    rename_column :identification_documents, :person_id, :documentable_id
    add_column :identification_documents, :documentable_type, :string
    change_column_null :identification_documents, :documentable_type, false
    add_index :identification_documents, [ :documentable_type, :documentable_id ]
    remove_index :identification_documents, :documentable_id if index_exists?(:identification_documents, :documentable_id)
  end
end
