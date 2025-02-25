require 'rails_helper'

RSpec.describe Match do
  describe 'associations' do
    it { should belong_to(:screening) }
  end

  describe '#properties' do
    it 'returns properties from external_data' do
      match = build(:match)
      expect(match.properties).to eq(match.external_data["properties"])
    end

    it 'returns empty hash when external_data is nil' do
      match = build(:match, :without_data)
      expect(match.properties).to eq({})
    end
  end

  describe '#schema' do
    it 'returns schema from external_data' do
      match = build(:match)
      expect(match.schema).to eq("Person")
    end

    it 'returns nil when external_data is nil' do
      match = build(:match, :without_data)
      expect(match.schema).to be_nil
    end
  end

  describe '#caption' do
    it 'returns caption from external_data' do
      match = build(:match)
      expect(match.caption).to eq("John Smith")
    end

    it 'returns nil when external_data is nil' do
      match = build(:match, :without_data)
      expect(match.caption).to be_nil
    end
  end

  describe '#aliases' do
    it 'returns aliases from properties' do
      match = build(:match)
      expect(match.aliases).to eq([ "Johnny", "J. Smith" ])
    end

    it 'returns empty array when aliases are not present' do
      match = build(:match)
      match.external_data["properties"]["alias"] = nil
      expect(match.aliases).to eq([])
    end
  end

  describe '#nationality' do
    it 'returns nationality from properties' do
      match = build(:match)
      expect(match.nationality).to eq([ "US" ])
    end
  end

  describe '#birth_date' do
    it 'returns birth date from properties' do
      match = build(:match)
      expect(match.birth_date).to eq([ "1980-01-01" ])
    end
  end

  describe '#address' do
    it 'returns address from properties' do
      match = build(:match)
      expect(match.address).to eq([ "123 Main St" ])
    end
  end

  describe '#sanctions' do
    it 'returns datasets from external_data' do
      match = build(:match)
      expect(match.sanctions).to eq([ "us_ofac", "eu_fsf" ])
    end

    it 'returns empty array when external_data is nil' do
      match = build(:match, :without_data)
      expect(match.sanctions).to eq([])
    end
  end

  describe '#topics' do
    it 'returns topics from properties' do
      match = build(:match)
      expect(match.topics).to eq([ "role.pep", "sanction.linked" ])
    end

    it 'returns empty array when topics are not present' do
      match = build(:match)
      match.external_data["properties"]["topics"] = nil
      expect(match.topics).to eq([])
    end
  end

  describe '#external_score' do
    it 'converts decimal score to percentage' do
      match = build(:match)
      expect(match.external_score).to eq(85)
    end
  end

  describe '#countries' do
    it 'returns unique combination of citizenship and country' do
      match = build(:match)
      expect(match.countries).to match_array([ "US", "GB" ])
    end

    it 'returns empty array when country and citizenship are nil' do
      match = build(:match)
      match.external_data["properties"]["country"] = nil
      match.external_data["properties"]["citizenship"] = nil
      expect(match.countries).to eq([])
    end

    it 'handles duplicate values between country and citizenship' do
      match = build(:match)
      match.external_data["properties"]["country"] = [ "FR", "DE" ]
      match.external_data["properties"]["citizenship"] = [ "FR", "IT" ]
      expect(match.countries).to match_array([ "FR", "DE", "IT" ])
    end
  end
end
