require 'rails_helper'

RSpec.describe RiskFactor, type: :model do
  describe 'associations' do
    it { should belong_to(:client) }
  end

  describe 'validations' do
    it { should validate_presence_of(:identifier) }
    it { should validate_presence_of(:category) }
  end

  describe 'enums' do
    it 'defines the correct enum values for category' do
      expect(described_class.categories).to eq(
        "business_relationship" => 0,
        "behavioral" => 1,
        "professional" => 2,
        "financing" => 3,
        "activity" => 4
      )
    end
  end

  describe '#active?' do
    it 'returns true when persisted' do
      risk_factor = create(:risk_factor)
      expect(risk_factor).to be_active
    end

    it 'returns false when not persisted' do
      risk_factor = build(:risk_factor)
      expect(risk_factor).not_to be_active
    end
  end
end
