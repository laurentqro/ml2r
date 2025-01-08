class CreateSanctions < ActiveRecord::Migration[8.0]
  def change
    create_table :sanctions do |t|
      t.string :nature
      t.string :title
      t.string :last_name
      t.string :first_name
      t.string :sex
      t.string :date_of_birth
      t.string :place_of_birth
      t.string :nationality
      t.text :address
      t.text :alias
      t.string :authority
      t.text :motive
      t.string :legal_basis
      t.text :additional_info
      t.string :expiration_date

      t.timestamps
    end
  end
end
