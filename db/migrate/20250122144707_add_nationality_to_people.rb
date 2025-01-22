class AddNationalityToPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :nationality, :string
  end
end
