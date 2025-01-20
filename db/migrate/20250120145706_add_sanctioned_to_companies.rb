class AddSanctionedToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :sanctioned, :boolean
  end
end
