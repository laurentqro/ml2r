class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :country_of_birth
      t.string :country_of_residence
      t.string :country_of_profession
      t.string :profession
      t.boolean :pep
      t.boolean :sanctioned

      t.timestamps
    end
  end
end
