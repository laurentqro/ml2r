require 'rails_helper'

RSpec.describe RiskFactor, type: :model do
  describe 'associations' do
    it { should belong_to(:person) }
  end

  describe 'validations' do
    it { should validate_presence_of(:identifier) }
    it { should validate_presence_of(:category) }

    describe 'uniqueness' do
      subject { create(:risk_factor) }

      it 'validates uniqueness of identifier scoped to person and category' do
        should validate_uniqueness_of(:identifier)
          .scoped_to([ :person_id, :category ])
      end
    end
  end

  describe 'enums' do
    it 'defines the correct enum values for category' do
      expect(described_class.categories).to eq(
        "business_relationship" => 0,
        "behavioral" => 1,
        "professional" => 2
      )
    end
  end

  describe '.identifiers_for' do
    it 'returns business relationship identifiers' do
      identifiers = described_class.identifiers_for(:business_relationship)
      expect(identifiers).to include(
        'not_identified_personally',
        'remote_relationship',
        'unreasonable_choice'
      )
    end

    it 'returns behavioral identifiers' do
      identifiers = described_class.identifiers_for(:behavioral)
      expect(identifiers).to include(
        'company_accounts_personal_use',
        'negative_legal_proceedings',
        'complex_structure'
      )
    end

    it 'returns professional identifiers' do
      identifiers = described_class.identifiers_for(:professional)
      expect(identifiers).to include(
        'retiree',
        'self_employed',
        'transport'
      )
    end
  end

  describe '#description' do
    it 'returns translated description' do
      risk_factor = build(:risk_factor,
        category: :business_relationship,
        identifier: 'not_identified_personally'
      )

      expect(risk_factor.description).to eq(
        'The person has not been identified personally by us / but presented by AML intermediary'
      )
    end
  end

  describe '#active?' do
    it 'returns true when identified_at is present' do
      risk_factor = build(:risk_factor, identified_at: Time.current)
      expect(risk_factor).to be_active
    end

    it 'returns false when identified_at is nil' do
      risk_factor = build(:risk_factor, identified_at: nil)
      expect(risk_factor).not_to be_active
    end
  end
end
