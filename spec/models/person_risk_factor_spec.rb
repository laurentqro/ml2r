require 'rails_helper'

RSpec.describe PersonRiskFactor, type: :model do
  let(:client) { create(:client, clientable: create(:person)) }

  describe 'validations' do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'enums' do
    it { should define_enum_for(:category).with_values([ :business_relationship, :behavioral, :professional ]) }
  end

  describe '.identifiers_for' do
    it 'returns correct identifiers for business_relationship category' do
      identifiers = described_class.identifiers_for(:business_relationship)
      expect(identifiers).to match_array([
        'not_identified_personally',
        'remote_relationship',
        'non_eu_intermediary',
        'unregulated_intermediary',
        'short_time_introducer'
      ])
    end

    it 'returns correct identifiers for behavioral category' do
      identifiers = described_class.identifiers_for(:behavioral)
      expect(identifiers).to match_array([
        'rushed_transactions',
        'disproportionate_funds',
        'avoids_meetings',
        'unusual_credit_terms'
      ])
    end

    it 'returns correct identifiers for professional category' do
      identifiers = described_class.identifiers_for(:professional)
      expect(identifiers).to match_array([
        'precious_stones_dealer',
        'antiques_art_dealer',
        'sensitive_materials_trader',
        'construction_influence',
        'gaming_establishment_owner',
        'cash_intensive_business'
      ])
    end
  end

  describe '#description' do
    it 'returns the correct translation' do
      risk_factor = create(:person_risk_factor,
        client: client,
        category: :behavioral,
        identifier: 'rushed_transactions'
      )

      expect(risk_factor.description).to eq("Rushed transactions")
    end
  end
end
