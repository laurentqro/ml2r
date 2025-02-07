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

def create_risk_scoresheet(client)
  RiskScoresheet.create!(
    client: client,
    country_risk_score: client.country_risk_score,
    client_risk_score: client.client_risk_score,
    products_and_services_risk_score: client.products_and_services_risk_score,
    distribution_channel_risk_score: client.distribution_channel_risk_score,
    transaction_risk_score: client.transaction_risk_score
  )
end

def create_random_risk_factors(client)
  # For each risk category, randomly select 0-3 risk factors
  client.available_risk_categories.each do |category|
    identifiers = client.risk_factor_class.identifiers_for(category)
    # Randomly select 0-3 identifiers
    selected_identifiers = identifiers.sample(rand(0..3))

    selected_identifiers.each do |identifier|
      client.risk_factor_class.create!(
        client: client,
        category: category,
        identifier: identifier,
        identified_at: Time.current
      )
    end
  end
end

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
    nationality: countries_pool.sample,
    profession: profession[0], # Store ISCO code
    pep: is_pep
  )

  # Create a client record for this person
  client = Client.create!(
    clientable: person,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )

  create_random_risk_factors(client)
  create_risk_scoresheet(client)
end

# Create 100 companies
100.times do |i|
  company = Company.create!(
    name: Faker::Company.name,
    country: HIGH_RISK_COUNTRIES.sample
  )

  client = Client.create!(
    clientable: company,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )

  create_random_risk_factors(client)
  create_risk_scoresheet(client)
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
    country_of_birth: HIGH_RISK_COUNTRIES.sample,
    country_of_residence: HIGH_RISK_COUNTRIES.sample,
    country_of_profession: HIGH_RISK_COUNTRIES.sample,
    profession: profession[0], # Store ISCO code
    nationality: HIGH_RISK_COUNTRIES.sample,
    pep: is_pep,
    sanctioned: true
  )

  client = Client.create!(
    clientable: person,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )

  create_random_risk_factors(client)
  RiskScoresheet.create_for_client!(client)
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

  create_random_risk_factors(client)
  create_risk_scoresheet(client)
end

# Create 50 companies from sanctions data
company_sanctions = Sanction.companies.limit(50)

company_sanctions.each do |sanction|
  company = Company.create!(
    name: sanction.last_name,
    country: HIGH_RISK_COUNTRIES.sample,
    sanctioned: true
  )

  client = Client.create!(
    clientable: company,
    started_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )

  create_random_risk_factors(client)
  RiskScoresheet.create_for_client!(client)
end
