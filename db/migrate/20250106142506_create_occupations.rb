class CreateOccupations < ActiveRecord::Migration[8.0]
  def change
    create_table :occupations do |t|
      t.string :major
      t.string :major_label
      t.string :sub_major
      t.string :sub_major_label
      t.string :minor
      t.string :minor_label
      t.string :unit
      t.string :description

      t.timestamps
    end
  end
end
