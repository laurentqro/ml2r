class DropRiskScoresheets < ActiveRecord::Migration[8.0]
  def change
    drop_table :risk_scoresheets do |t|
      t.references :client, null: false, foreign_key: true
      t.integer :country_risk_score
      t.integer :client_risk_score
      t.integer :products_and_services_risk_score
      t.integer :distribution_channel_risk_score
      t.integer :transaction_risk_score
      t.datetime :approved_at
      t.text :notes
      t.timestamps
    end
  end
end 