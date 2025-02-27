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

def create_random_person_risk_factors(client)
  # For each risk category, randomly select 0-3 risk factors
  RiskFactorDefinition.person_risk_factors.each do |definition|
    client.person_risk_factors.create!(
      category: definition.category,
      identifier: definition.identifier,
      score: definition.score
    )
  end
end

def create_random_company_risk_factors(client)
  RiskFactorDefinition.company_risk_factors.each do |definition|
    client.company_risk_factors.create!(
      category: definition.category,
      identifier: definition.identifier,
      score: definition.score
    )
  end
end


def create_risk_factor_definitions(risk_factors, risk_factor_type)
  risk_factors.each do |category, descriptions|
    descriptions.each do |identifier, description|
      RiskFactorDefinition.create!(
        risk_factor_type: risk_factor_type,
        identifier: identifier.to_s,
        category: category,
        description: description,
        score: rand(1..50)
      )
    end
  end
end

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

  create_random_person_risk_factors(client)
  create_risk_scoresheet(client)
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

  create_random_company_risk_factors(client)
  create_risk_scoresheet(client)
end

# Create risk scoresheets for clients
Client.all.each do |client|
  create_risk_scoresheet(client)
end

person_risk_factors = {
  client_risk: {
    rushed_transactions: "Client wants to complete the transaction quickly for no apparent reason",
    trust_or_foundation: "Client is a trust or foundation",
    precious_stones_dealer: "Client is a precious stones dealer",
    antiques_art_dealer: "Client is an antiques/artwork dealer",
    sensitive_materials_trader: "Client is a sensitive materials trader (oil, raw materials, arms)",
    construction_influence: "Client has influence in construction/public works",
    gaming_establishment_owner: "Client is a casino or gaming establishment owner",
    cash_intensive_business: "Client is a cash-intensive business"
  },
  products_and_services_risk: {
    new_build_sale: "Client is selling or buying a new build property",
    existing_build_sale: "Client is selling or buying an existing build property",
    main_residence_rental_above_threshold: "Client is renting their main residence for more than 10 000 euros",
    secondary_residence_rental_above_threshold: "Client is renting their secondary residence for more than 10 000 euros"
  },
  distribution_channel_risk: {
    remote_relationship: "The relationship is remote",
    presence_of_intermediary: "An intermediary is involved"
  },
  transaction_risk: {
    means_of_payment: "The means of payment is unusual",
    transaction_amount: "The transaction amount is high",
    transaction_frequency: "The transaction frequency is high",
    fractioned_payments: "The payments are fractioned",
    complex_transactions: "The transactions are complex",
    manipulation_of_property_value: "The property value appears to be manipulated (over or under-valuation)"
  }
}


company_risk_factors = {
  client_risk: {
    subject_of_legal_proceedings: "Subject of legal proceedings",
    corruption_risk: "Company operates in country with high risk of corruption",
    government_related: "Government or public sector related",
    holding_company: "Holding company",
    charity_trust: "Charity-oriented trust",
    construction_related: "Active in construction/public works",
    cash_intensive: "Cash-intensive business operations",
    complex_structure: "Complex business structure"
  },
  products_and_services_risk: {
    new_build_sale: "Client is selling or buying a new build property",
    existing_build_sale: "Client is selling or buying an existing build property",
    main_residence_rental_above_threshold: "Client is renting their main residence for more than 10 000 euros",
    secondary_residence_rental_above_threshold: "Client is renting their secondary residence for more than 10 000 euros"
  },
  distribution_channel_risk: {
    remote_relationship: "The relationship is remote",
    presence_of_intermediary: "An intermediary is involved"
  },
  transaction_risk: {
    means_of_payment: "The means of payment is unusual",
    transaction_amount: "The transaction amount is high",
    transaction_frequency: "The transaction frequency is high",
    fractioned_payments: "The payments are fractioned",
    complex_transactions: "The transactions are complex",
    manipulation_of_property_value: "The property value appears to be manipulated (over or under-valuation)"
  }
}

create_risk_factor_definitions(person_risk_factors, "PersonRiskFactor")
create_risk_factor_definitions(company_risk_factors, "CompanyRiskFactor")
