require 'rails_helper'

RSpec.describe CompanyRiskFactor, type: :model do
  let(:client) { create(:client, clientable: create(:company)) }

  describe 'validations' do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'enums' do
    it { should define_enum_for(:category).with_values([ :financing, :behavioral, :activity ]) }
  end

  describe '.identifiers_for' do
    it 'returns correct identifiers for financing category' do
      identifiers = described_class.identifiers_for(:financing)
      expect(identifiers).to match_array([
        :financed_by_beneficial_owners,
        :financed_by_parent_company,
        :financed_by_settlor,
        :publicly_traded
      ])
    end

    it 'returns correct identifiers for behavioral category' do
      identifiers = described_class.identifiers_for(:behavioral)
      expect(identifiers).to match_array([
        :subject_of_legal_proceedings,
        :corruption_risk,
        :cheque_deposits
      ])
    end

    it 'returns correct identifiers for activity category' do
      identifiers = described_class.identifiers_for(:activity)
      expect(identifiers).to match_array([
        :government_related,
        :holding_company,
        :charity_trust,
        :construction_related,
        :cash_intensive,
        :virtual_assets,
        :offshore_business,
        :complex_structure,
        :shell_company,
        :high_risk_jurisdiction
      ])
    end
  end

  describe '#description' do
    it 'returns the correct translation' do
      risk_factor = create(:company_risk_factor,
        client: client,
        category: :financing,
        identifier: :financed_by_beneficial_owners
      )

      expect(risk_factor.description).to eq("Financed by beneficial owners")
    end
  end
end
