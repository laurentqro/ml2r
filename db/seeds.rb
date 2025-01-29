# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Client.delete_all
Person.delete_all
Company.delete_all

# Common countries with ISO 3166-1 alpha-2 codes
COMMON_COUNTRIES = [
  'FR', # France
  'IT', # Italy
  'MC', # Monaco
  'CH', # Switzerland
  'GB', # United Kingdom
  'DE', # Germany
  'US', # United States
  'RU', # Russia
  'CN', # China
  'SA', # Saudi Arabia
  'AE'  # United Arab Emirates
]

# High-risk countries
HIGH_RISK_COUNTRIES = [
  'IR', # Iran
  'KP', # North Korea
  'SY', # Syria
  'VE', # Venezuela
  'MM'  # Myanmar
]

# ISCO-08 codes and corresponding job titles for relevant professions
# Format: [ISCO code, title, pep_likely (boolean)]
PROFESSIONS = [
  [ 1112, 'Senior Government Official', true ],
  [ 1114, 'Senior Political Party Official', true ],
  [ 1113, 'Traditional Chief or Head of Village', true ],
  [ 2422, 'Policy Administration Professional', true ],
  [ 2612, 'Judge', true ],
  [ 0110, 'Military Officer', true ], # Commissioned armed forces officers
  [ 1120, 'Managing Director or Chief Executive', false ],
  [ 2611, 'Lawyer', false ],
  [ 2211, 'Medical Doctor', false ],
  [ 2413, 'Financial Analyst', false ],
  [ 3311, 'Investment Broker', false ],
  [ 2120, 'Mathematician or Actuary', false ],
  [ 2631, 'Economist', false ]
]

# Create 100 people
100.times do |i|
  # 10% chance of being from a high-risk country
  countries_pool = rand < 0.1 ? HIGH_RISK_COUNTRIES : COMMON_COUNTRIES

  # 15% chance of being a PEP
  is_pep = rand < 0.15

  # Select profession based on PEP status
  profession = if is_pep
    # PEPs more likely to have government/political roles
    PROFESSIONS.select { |p| p[2] }.sample
  else
    PROFESSIONS.sample
  end

  person = Person.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    country_of_birth: countries_pool.sample,
    country_of_residence: countries_pool.sample,
    country_of_profession: countries_pool.sample,
    profession: profession[0], # Store ISCO code
    pep: is_pep
  )

  # Create a client record for this person
  Client.create!(
    clientable: person,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end

# Create 100 companies
100.times do |i|
  company = Company.create!(
    name: Faker::Company.name,
    country: HIGH_RISK_COUNTRIES.sample
  )

  Client.create!(
    clientable: company,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end

# Create 50 sanctioned people
person_sanctions = Sanction.individuals.limit(50)

person_sanctions.each do |sanction|
  # 40% chance of being a PEP for sanctioned individuals
  is_pep = rand < 0.4

  # Select profession based on PEP status
  profession = if is_pep
    PROFESSIONS.select { |p| p[2] }.sample
  else
    PROFESSIONS.sample
  end

  # Create person with sanction data
  person = Person.create!(
    first_name: sanction.first_name,
    last_name: sanction.last_name,
    country_of_birth: sanction.place_of_birth,
    country_of_residence: HIGH_RISK_COUNTRIES.sample,
    country_of_profession: HIGH_RISK_COUNTRIES.sample,
    profession: profession[0], # Store ISCO code
    nationality: HIGH_RISK_COUNTRIES.sample,
    pep: is_pep,
    sanctioned: true
  )

  # Create a client record for this person
  Client.create!(
    clientable: person,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end

# Create 50 companies from sanctions data
company_sanctions = Sanction.companies.limit(50)

company_sanctions.each do |sanction|
  # Create company with sanction data
  company = Company.create!(
    name: sanction.last_name,
    country: HIGH_RISK_COUNTRIES.sample,
    sanctioned: true
  )

  # Create a client record for this company
  Client.create!(
    clientable: company,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end
