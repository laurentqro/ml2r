require 'rails_helper'

RSpec.describe PersonRiskFactor, type: :model do
  let(:client) { create(:client, clientable: create(:person)) }

  before do
    create(:person_client_risk_factor_definition, identifier: :subject_of_legal_proceedings, score: 10)
    create(:person_products_and_services_risk_factor_definition, identifier: :new_build_sale, score: 15)
    create(:person_distribution_channel_risk_factor_definition, identifier: :remote_relationship, score: 20)
    create(:person_transaction_risk_factor_definition, identifier: :means_of_payment, score: 25)
  end

  describe 'validations' do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'enums' do
    it { should define_enum_for(:category)
      .with_values([
        :client_risk,
        :products_and_services_risk,
        :distribution_channel_risk,
        :transaction_risk
      ])
    }
  end

  describe '.identifiers_for' do
    it 'returns correct identifiers for client_risk category' do
      expect(PersonRiskFactor.identifiers_for(:client_risk)).to match_array([ :subject_of_legal_proceedings ])
    end

    it 'returns correct identifiers for products_and_services_risk category' do
      expect(PersonRiskFactor.identifiers_for(:products_and_services_risk)).to match_array([ :new_build_sale ])
    end

    it 'returns correct identifiers for the distribution_channel_risk category' do
      expect(PersonRiskFactor.identifiers_for(:distribution_channel_risk)).to match_array([ :remote_relationship ])
    end

    it 'returns correct identifiers for the transaction_risk category' do
      expect(PersonRiskFactor.identifiers_for(:transaction_risk)).to match_array([ :means_of_payment ])
    end
  end

  describe '#description' do
    it 'returns the correct translation' do
      risk_factor = create(:person_risk_factor,
        client: client,
        category: :client_risk,
        identifier: :subject_of_legal_proceedings
      )

      expect(risk_factor.description).to eq("Subject of legal proceedings")
    end
  end
end
