# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed data for people table with standardized country and occupation codes
# require 'faker'

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
  [1112, 'Senior Government Official', true],
  [1114, 'Senior Political Party Official', true],
  [1113, 'Traditional Chief or Head of Village', true],
  [2422, 'Policy Administration Professional', true],
  [2612, 'Judge', true],
  [0110, 'Military Officer', true], # Commissioned armed forces officers
  [1120, 'Managing Director or Chief Executive', false],
  [2611, 'Lawyer', false],
  [2211, 'Medical Doctor', false],
  [2413, 'Financial Analyst', false],
  [3311, 'Investment Broker', false],
  [2120, 'Mathematician or Actuary', false],
  [2631, 'Economist', false]
]

# Create 100 people records
100.times do |i|
  # 10% chance of being from a high-risk country
  countries_pool = rand < 0.1 ? HIGH_RISK_COUNTRIES : COMMON_COUNTRIES

  # 15% chance of being a PEP
  is_pep = rand < 0.15

  # 5% chance of being sanctioned, higher if from high-risk country
  is_sanctioned = if HIGH_RISK_COUNTRIES.include?(countries_pool.first)
    rand < 0.3  # 30% chance if from high-risk country
  else
    rand < 0.05 # 5% chance otherwise
  end

  # Select profession based on PEP status
  profession = if is_pep
    # PEPs more likely to have government/political roles
    PROFESSIONS.select { |p| p[2] }.sample
  else
    PROFESSIONS.sample
  end

  Person.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    country_of_birth: countries_pool.sample,
    country_of_residence: countries_pool.sample,
    country_of_profession: countries_pool.sample,
    profession: profession[0] # Store ISCO code
  )
end

# Log summary statistics
total_peps = Person.where(pep: true).count
total_sanctioned = Person.where(sanctioned: true).count
high_risk_residents = Person.where(country_of_residence: HIGH_RISK_COUNTRIES).count

puts "Created 100 people records:"
puts "- #{total_peps} PEPs"
puts "- #{total_sanctioned} sanctioned individuals"
puts "- #{high_risk_residents} residents of high-risk countries"
