class ClientRiskSummary < ApplicationRecord
  self.primary_key = "client_id"

  belongs_to :client

  def readonly?
    true
  end
end
