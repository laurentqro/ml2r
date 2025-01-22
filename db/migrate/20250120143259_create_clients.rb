class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.belongs_to :clientable, polymorphic: true
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end

    add_index :clients, [ :clientable_id, :clientable_type ]
  end
end
