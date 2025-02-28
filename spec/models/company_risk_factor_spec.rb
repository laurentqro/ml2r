require 'rails_helper'

RSpec.describe CompanyRiskFactor, type: :model do
  let(:client) { create(:client, clientable: create(:company)) }

  before do
    create(:company_client_risk_factor_definition, score: 10)
    create(:company_products_and_services_risk_factor_definition, score: 15)
    create(:company_distribution_channel_risk_factor_definition, score: 20)
    create(:company_transaction_risk_factor_definition, score: 25)
  end

  describe 'validations' do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'enums' do
    it { should define_enum_for(:category)
      .with_values([ :client_risk, :products_and_services_risk, :distribution_channel_risk, :transaction_risk ])
    }
  end

  describe '.identifiers_for' do
    it 'returns correct identifiers for client_risk category' do
      expect(CompanyRiskFactor.identifiers_for(:client_risk)).to match_array([
        :subject_of_legal_proceedings
      ])
    end

    it 'returns correct identifiers for products_and_services_risk category' do
      expect(CompanyRiskFactor.identifiers_for(:products_and_services_risk)).to match_array([
        :new_build_sale
      ])
    end

    it 'returns correct identifiers for distribution_channel_risk category' do
      expect(CompanyRiskFactor.identifiers_for(:distribution_channel_risk)).to match_array([
        :remote_relationship
      ])
    end

    it 'returns correct identifiers for transaction_risk category' do
      expect(CompanyRiskFactor.identifiers_for(:transaction_risk)).to match_array([
        :means_of_payment
      ])
    end
  end

  describe '#description' do
    it 'returns the correct description for client_risk category' do
      risk_factor = create(:company_risk_factor,
        client: client,
        category: :client_risk,
        identifier: :subject_of_legal_proceedings
      )

      expect(risk_factor.description).to eq("Subject of legal proceedings")
      end

    it 'returns the correct description for products_and_services_risk category' do
      risk_factor = create(:company_risk_factor,
        client: client,
        category: :products_and_services_risk,
        identifier: :new_build_sale
      )

      expect(risk_factor.description).to eq("New build sale")
    end

    it 'returns the correct description for distribution_channel_risk category' do
      risk_factor = create(:company_risk_factor,
        client: client,
        category: :distribution_channel_risk,
        identifier: :remote_relationship
      )

      expect(risk_factor.description).to eq("Remote relationship")
    end

    it 'returns the correct description for transaction_risk category' do
      risk_factor = create(:company_risk_factor,
        client: client,
        category: :transaction_risk,
        identifier: :means_of_payment
      )

      expect(risk_factor.description).to eq("Means of payment")
    end
  end
end
