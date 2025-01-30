class AddScoreToMatches < ActiveRecord::Migration[8.0]
  def change
    add_column :matches, :score, :integer, default: 0
  end
end
