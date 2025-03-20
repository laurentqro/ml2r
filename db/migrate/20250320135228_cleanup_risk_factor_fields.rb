class CleanupRiskFactorFields < ActiveRecord::Migration[8.0]
  def up
    remove_reference :risk_factors, :client
    remove_column :risk_factors, :identifier
  end

  def down
    add_reference :risk_factors, :client
    add_column :risk_factors, :identifier, :string
  end
end
