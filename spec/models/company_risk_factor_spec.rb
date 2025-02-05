require 'rails_helper'

RSpec.describe CompanyRiskFactor, type: :model do
  let(:client) { create(:client, clientable: create(:company)) }

  describe 'validations' do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'enums' do
    it { should define_enum_for(:category).with_values([ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ]) }
  end

  describe '.identifiers_for' do
    it 'returns correct identifiers for client_risk category' do
      identifiers = described_class.identifiers_for(:client_risk)
      expect(identifiers).to match_array([
        :subject_of_legal_proceedings,
        :corruption_risk,
        :government_related,
        :holding_company,
        :charity_trust,
        :construction_related,
        :cash_intensive,
        :complex_structure
      ])
    end

    it 'returns correct identifiers for products_and_services_risk category' do
      identifiers = described_class.identifiers_for(:products_and_services_risk)
      expect(identifiers).to match_array([
        :new_build_sale,
        :existing_build_sale,
        :main_residence_rental_above_10_000_euros,
        :secondary_residence_rental_above_10_000_euros
      ])
    end

    it 'returns correct identifiers for distribution_channel_risk category' do
      identifiers = described_class.identifiers_for(:distribution_channel_risk)
      expect(identifiers).to match_array([
        :remote_relationship,
        :presence_of_intermediary
      ])
    end

    it 'returns correct identifiers for transaction_risk category' do
      identifiers = described_class.identifiers_for(:transaction_risk)
      expect(identifiers).to match_array([
        :means_of_payment,
        :transaction_amount,
        :transaction_frequency,
        :fractioned_payments,
        :complex_transactions,
        :manipulation_of_property_value
      ])
    end
  end

  describe '#description' do
    it 'returns the correct translation' do
      risk_factor = create(:company_risk_factor,
        client: client,
        category: :client_risk,
        identifier: :subject_of_legal_proceedings
      )

      expect(risk_factor.description).to eq("Subject of legal proceedings")
    end
  end
end
