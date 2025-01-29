class Match < ApplicationRecord
  belongs_to :screening
  belongs_to :sanction, foreign_key: :measure_id, primary_key: :measure_id
end
