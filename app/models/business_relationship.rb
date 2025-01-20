class BusinessRelationship < ApplicationRecord
  belongs_to :clientable, polymorphic: true
end
