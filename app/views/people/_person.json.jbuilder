json.extract! person, :id, :first_name, :last_name, :country_of_birth, :country_of_residence, :country_of_profession, :profession, :pep, :sanctioned, :created_at, :updated_at
json.url person_url(person, format: :json)
