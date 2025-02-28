class Occupation < ApplicationRecord
  default_scope { order(major_label: :asc, description: :asc) }

  def long_description
    "#{major_label} > #{description}"
  end
end
