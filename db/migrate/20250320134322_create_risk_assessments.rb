class CreateRiskAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :risk_assessments do |t|
      t.references :client, null: false, foreign_key: true
      t.integer :status, default: 0, null: false # default: pending
      t.datetime :completed_at
      t.datetime :approved_at
      t.string :approver_name
      t.text :notes

      t.timestamps
    end

    add_index :risk_assessments, :status
    add_index :risk_assessments, :completed_at
    add_index :risk_assessments, :approved_at
  end
end
