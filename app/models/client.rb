class Client < ApplicationRecord
  belongs_to :clientable, polymorphic: true
end
