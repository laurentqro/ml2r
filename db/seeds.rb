# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)

# Common countries with ISO 3166-1 alpha-2 codes
COMMON_COUNTRIES = [
  'FR', # France
  'IT', # Italy
  'MC', # Monaco
  'CH', # Switzerland
  'GB', # United Kingdom
  'DE', # Germany
  'US', # United States
  'AR', # Argentina
  'ES', # Spain
  'PT', # Portugal
  'BE', # Belgium
  'NL', # Netherlands
  'SE', # Sweden
  'NO', # Norway
  'DK', # Denmark
  'AU', # Australia
  'NZ', # New Zealand
  'CA', # Canada
  'JP', # Japan
  'KR' # South Korea

]

# High-risk countries
HIGH_RISK_COUNTRIES = [
  'SY', # Syria
  'VE', # Venezuela
  'RU', # Russia
  'CN', # China
  'SA', # Saudi Arabia
  'AE'  # United Arab Emirates
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

def create_risk_factor_definitions(entity_type)
  RiskFactorDefinition::CATEGORIES.each do |category|
    RiskFactorDefinition.create!(
      entity_type: entity_type,
      category: category,
      description: Faker::Lorem.sentence,
      score: rand(1..50)
    )
  end
end

create_risk_factor_definitions("Person")
create_risk_factor_definitions("Company")

# Create 100 people
100.times do |i|
  countries_pool = rand < 0.1 ? HIGH_RISK_COUNTRIES : COMMON_COUNTRIES

  person = Person.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    country_of_birth: countries_pool.sample,
    country_of_residence: countries_pool.sample,
    country_of_profession: countries_pool.sample,
    nationality: countries_pool.sample,
    profession: PROFESSIONS.sample
  )

  client = Client.create!(
    clientable: person,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end

# Create 100 companies
100.times do |i|
  countries_pool = rand < 0.1 ? HIGH_RISK_COUNTRIES : COMMON_COUNTRIES

  company = Company.create!(
    name: Faker::Company.name,
    country: countries_pool.sample
  )

  client = Client.create!(
    clientable: company,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end
