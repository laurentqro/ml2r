class ChangeAdverseMediaChecksToPolymorphic < ActiveRecord::Migration[8.0]
  def up
    remove_column :adverse_media_checks, :client_id
    add_column :adverse_media_checks, :adverse_media_checkable_id, :integer
    add_column :adverse_media_checks, :adverse_media_checkable_type, :string
    add_index :adverse_media_checks, [:adverse_media_checkable_id, :adverse_media_checkable_type]
  end

  def down
    remove_column :adverse_media_checks, :am_checkable_id
    remove_column :adverse_media_checks, :am_checkable_type
    add_column :adverse_media_checks, :client_id, :integer
  end
end
