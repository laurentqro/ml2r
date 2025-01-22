class CreateBusinessRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :business_relationships do |t|
      t.belongs_to :clientable, polymorphic: true
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end

    add_index :business_relationships, [ :clientable_id, :clientable_type ]
  end
end
