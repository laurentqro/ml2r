class Person < ApplicationRecord
  def last_first_name
    "#{last_name}, #{first_name}"
  end
end
