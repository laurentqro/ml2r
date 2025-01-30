require 'rails_helper'

RSpec.describe Client do
  describe '#risk_score' do
    let(:person) do
      Person.new(
        country_of_residence: 'DK',    # Low risk (90)
        nationality: 'VN',             # Medium risk + greylist
        country_of_profession: 'GB',   # Low risk
        country_of_birth: 'SO'         # High risk
      )
    end

    let(:client) { described_class.new(clientable: person) }

    it 'calculates weighted risk score from all countries' do
      risk_score = client.risk_score

      # Expected calculations:
      # DK (residence):    10 * 40 = 400     (100 - 90 = 10)
      # VN (nationality):  118 * 35 = 4130   ((100 - 41) * 2 = 118)
      # GB (profession):   29 * 15 = 435     (100 - 71 = 29)
      # SO (birth):        89 * 10 = 890     (100 - 11 = 89)
      # Total weight: 100
      # Expected score: (400 + 4130 + 435 + 890) / 100 = 5855 / 100 = 58.55 ≈ 59

      expect(risk_score).to eq(59)
    end

    it 'returns infinity for blacklisted countries' do
      person.nationality = 'IR' # Iran - blacklisted
      expect(client.risk_score).to eq(Float::INFINITY)
    end

    it 'handles missing country data' do
      person.country_of_residence = nil
      person.nationality = nil
      
      risk_score = client.risk_score

      # Only profession and birth country present
      # GB (profession):   29 * 15 = 435
      # SO (birth):        89 * 10 = 890
      # Total weight: 25
      # Expected: (435 + 890) / 25 = 53
      
      expect(risk_score).to eq(53)
    end

    it 'returns 0 when no country data is present' do
      person.country_of_residence = nil
      person.nationality = nil
      person.country_of_profession = nil
      person.country_of_birth = nil
      
      expect(client.risk_score).to eq(0)
    end

    context "with company client" do
      let(:company) do
        Company.new(
          country: 'GB'  # Low risk
        )
      end

      let(:client) { described_class.new(clientable: company) }

      it 'calculates risk score from company country' do
        risk_score = client.risk_score

        # Expected calculations:
        # GB: 29 * 100 = 2900  (100 - 71 = 29)
        # Total weight: 100
        # Expected score: 2900 / 100 = 29

        expect(risk_score).to eq(29)
      end

      it 'returns infinity for blacklisted company country' do
        company.country = 'IR' # Iran - blacklisted
        expect(client.risk_score).to eq(Float::INFINITY)
      end

      it 'returns 0 when no country data is present' do
        company.country = nil
        expect(client.risk_score).to eq(0)
      end
    end
  end

  describe "validations" do
    let(:person) do
      Person.new(
        country_of_residence: 'DK',
        nationality: 'KP',  # North Korea - blacklisted
        country_of_profession: 'GB',
        country_of_birth: 'FR'
      )
    end
    
    let(:client) { described_class.new(clientable: person) }

    it "is invalid if client has ties to blacklisted countries" do
      expect(client).not_to be_valid
      expect(client.errors[:base]).to include("Cannot onboard clients with ties to GAFI blacklisted countries")
    end

    it "is valid without blacklisted countries" do
      person.nationality = 'GB'
      expect(client).to be_valid
    end
  end

  describe "#blacklisted?" do
    let(:person) { Person.new }
    let(:client) { described_class.new(clientable: person) }

    it "returns true if any country is blacklisted" do
      person.nationality = 'IR' # Iran - blacklisted
      expect(client).to be_blacklisted
    end

    it "returns false if no countries are blacklisted" do
      person.nationality = 'GB'
      person.country_of_residence = 'FR'
      expect(client).not_to be_blacklisted
    end
  end
end 