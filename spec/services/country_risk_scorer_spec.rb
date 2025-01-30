require 'rails_helper'

RSpec.describe CountryRiskScorer do
  describe '.perceived_corruption_index' do
    it 'returns the CPI score for a known country' do
      expect(described_class.perceived_corruption_index('DK')).to eq(90)
      expect(described_class.perceived_corruption_index('SO')).to eq(11)
    end

    it 'returns 50 for unknown countries' do
      expect(described_class.perceived_corruption_index('XX')).to eq(50)
    end
  end

  describe '.gafi_status' do
    it 'returns :black for blacklisted countries' do
      expect(described_class.gafi_status('KP')).to eq(:black)
      expect(described_class.gafi_status('IR')).to eq(:black)
    end

    it 'returns :grey for greylisted countries' do
      expect(described_class.gafi_status('VN')).to eq(:grey)
      expect(described_class.gafi_status('YE')).to eq(:grey)
    end

    it 'returns nil for non-listed countries' do
      expect(described_class.gafi_status('US')).to be_nil
    end
  end

  describe '.calculate_risk_score' do
    it 'returns triple risk for blacklisted countries' do
      base_score = 100 - described_class.perceived_corruption_index('KP')
      expect(described_class.calculate_risk_score('KP')).to eq(base_score * 3)
    end

    it 'returns double risk for greylisted countries' do
      base_score = 100 - described_class.perceived_corruption_index('VN')
      expect(described_class.calculate_risk_score('VN')).to eq(base_score * 2)
    end

    it 'returns normal risk for non-listed countries' do
      expect(described_class.calculate_risk_score('DK')).to eq(10) # 100 - 90
      expect(described_class.calculate_risk_score('SO')).to eq(89) # 100 - 11
    end
  end
end 