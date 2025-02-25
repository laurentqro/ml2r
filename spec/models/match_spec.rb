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

  describe '#last_change' do
    it 'returns parsed time from external_data' do
      match = build(:match)
      expect(match.last_change).to be_a(Time)
    end
  end

  describe '#last_seen' do
    it 'returns parsed time from external_data' do
      match = build(:match)
      expect(match.last_seen).to be_a(Time)
    end
  end

  describe '#first_seen' do
    it 'returns parsed time from external_data' do
      match = build(:match)
      expect(match.first_seen).to be_a(Time)
    end
  end

  describe '#aliases' do
    it 'returns aliases from properties' do
      match = build(:match)
      expect(match.aliases).to eq([ "J. Smith", "Johnny" ])
    end

    it 'returns empty array when aliases are not present' do
      match = build(:match)
      match.external_data["properties"]["alias"] = nil
      expect(match.aliases).to eq([])
    end
  end

  describe '#weak_aliases' do
    it 'returns weak aliases from properties' do
      match = build(:match)
      expect(match.weak_aliases).to eq([ "JS", "Smith" ])
    end

    it 'returns empty array when weak aliases are not present' do
      match = build(:match)
      match.external_data["properties"]["weakAlias"] = nil
      expect(match.weak_aliases).to eq([])
    end
  end

  describe '#first_name' do
    it 'returns first name from properties' do
      match = build(:match)
      expect(match.first_name).to eq([ "John" ])
    end

    it 'returns empty array when first name is not present' do
      match = build(:match)
      match.external_data["properties"]["firstName"] = nil
      expect(match.first_name).to eq([])
    end
  end

  describe '#last_name' do
    it 'returns last name from properties' do
      match = build(:match)
      expect(match.last_name).to eq([ "Smith" ])
    end

    it 'returns empty array when last name is not present' do
      match = build(:match)
      match.external_data["properties"]["lastName"] = nil
      expect(match.last_name).to eq([])
    end
  end

  describe '#father_name' do
    it 'returns father name from properties' do
      match = build(:match)
      expect(match.father_name).to eq([ "Robert" ])
    end

    it 'returns empty array when father name is not present' do
      match = build(:match)
      match.external_data["properties"]["fatherName"] = nil
      expect(match.father_name).to eq([])
    end
  end

  describe '#second_name' do
    it 'returns second name from properties' do
      match = build(:match)
      expect(match.second_name).to eq([ "Michael" ])
    end

    it 'returns empty array when second name is not present' do
      match = build(:match)
      match.external_data["properties"]["secondName"] = nil
      expect(match.second_name).to eq([])
    end
  end

  describe '#title' do
    it 'returns title from properties' do
      match = build(:match)
      expect(match.title).to eq([ "Mr." ])
    end

    it 'returns empty array when title is not present' do
      match = build(:match)
      match.external_data["properties"]["title"] = nil
      expect(match.title).to eq([])
    end
  end

  describe '#name' do
    it 'returns name from properties' do
      match = build(:match)
      expect(match.name).to eq([ "John Smith" ])
    end

    it 'returns empty array when name is not present' do
      match = build(:match)
      match.external_data["properties"]["name"] = nil
      expect(match.name).to eq([])
    end
  end

  describe '#nationality' do
    it 'returns nationality from properties' do
      match = build(:match)
      expect(match.nationality).to eq([ "United States" ])
    end

    it 'returns empty array when nationality is not present' do
      match = build(:match)
      match.external_data["properties"]["nationality"] = nil
      expect(match.nationality).to eq([])
    end
  end

  describe '#citizenship' do
    it 'returns citizenship from properties' do
      match = build(:match)
      expect(match.citizenship).to be_an(Array)
    end

    it 'returns empty array when citizenship is not present' do
      match = build(:match)
      match.external_data["properties"]["citizenship"] = nil
      expect(match.citizenship).to eq([])
    end
  end

  describe '#wikidata_id' do
    it 'returns wikidata ID from properties' do
      match = build(:match)
      expect(match.wikidata_id).to eq([ "Q12345" ])
    end

    it 'returns empty array when wikidata ID is not present' do
      match = build(:match)
      match.external_data["properties"]["wikidataId"] = nil
      expect(match.wikidata_id).to eq([])
    end
  end

  describe '#position' do
    it 'returns position from properties' do
      match = build(:match)
      expect(match.position).to eq([ "CEO" ])
    end

    it 'returns empty array when position is not present' do
      match = build(:match)
      match.external_data["properties"]["position"] = nil
      expect(match.position).to eq([])
    end
  end

  describe '#education' do
    it 'returns education from properties' do
      match = build(:match)
      expect(match.education).to eq([ "Harvard University" ])
    end

    it 'returns empty array when education is not present' do
      match = build(:match)
      match.external_data["properties"]["education"] = nil
      expect(match.education).to eq([])
    end
  end

  describe '#religion' do
    it 'returns religion from properties' do
      match = build(:match)
      expect(match.religion).to eq([ "Christianity" ])
    end

    it 'returns empty array when religion is not present' do
      match = build(:match)
      match.external_data["properties"]["religion"] = nil
      expect(match.religion).to eq([])
    end
  end

  describe '#source_url' do
    it 'returns source URLs from properties' do
      match = build(:match)
      expect(match.source_url).to eq([ "https://example.com" ])
    end

    it 'returns empty array when source URLs are not present' do
      match = build(:match)
      match.external_data["properties"]["sourceUrl"] = nil
      expect(match.source_url).to eq([])
    end

    it 'removes trailing slashes from URLs' do
      match = build(:match)
      match.external_data["properties"]["sourceUrl"] = [ "https://example.com/" ]
      expect(match.source_url).to eq([ "https://example.com" ])
    end
  end

  describe '#birth_date' do
    it 'returns birth date from properties' do
      match = build(:match)
      expect(match.birth_date).to eq([ "1980-01-01" ])
    end

    it 'returns empty array when birth date is not present' do
      match = build(:match)
      match.external_data["properties"]["birthDate"] = nil
      expect(match.birth_date).to eq([])
    end
  end

  describe '#website' do
    it 'returns website from properties' do
      match = build(:match)
      expect(match.website).to eq([ "https://johnsmith.com" ])
    end

    it 'returns empty array when website is not present' do
      match = build(:match)
      match.external_data["properties"]["website"] = nil
      expect(match.website).to eq([])
    end

    it 'removes trailing slashes from URLs' do
      match = build(:match)
      match.external_data["properties"]["website"] = [ "https://johnsmith.com/" ]
      expect(match.website).to eq([ "https://johnsmith.com" ])
    end
  end

  describe '#address' do
    it 'returns address from properties' do
      match = build(:match)
      expect(match.address).to eq([ "123 Main St" ])
    end

    it 'returns empty array when address is not present' do
      match = build(:match)
      match.external_data["properties"]["address"] = nil
      expect(match.address).to eq([])
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

  describe '#country' do
    it 'returns country from properties' do
      match = build(:match)
      expect(match.country).to be_an(Array)
    end

    it 'returns empty array when country is not present' do
      match = build(:match)
      match.external_data["properties"]["country"] = nil
      expect(match.country).to eq([])
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

  describe '#gender' do
    it 'returns gender from properties' do
      match = build(:match)
      expect(match.gender).to eq("male")
    end

    it 'returns nil when gender is not present' do
      match = build(:match)
      match.external_data["properties"]["gender"] = nil
      expect(match.gender).to be_nil
    end
  end

  describe '#birth_place' do
    it 'returns birth place from properties' do
      match = build(:match)
      expect(match.birth_place).to eq([ "New York" ])
    end

    it 'returns empty array when birth place is not present' do
      match = build(:match)
      match.external_data["properties"]["birthPlace"] = nil
      expect(match.birth_place).to eq([])
    end
  end

  describe '#birth_country' do
    it 'returns birth country from properties' do
      match = build(:match)
      expect(match.birth_country).to eq([ "United States" ])
    end

    it 'returns empty array when birth country is not present' do
      match = build(:match)
      match.external_data["properties"]["birthCountry"] = nil
      expect(match.birth_country).to eq([])
    end
  end

  describe '#ethnicity' do
    it 'returns ethnicity from properties' do
      match = build(:match)
      expect(match.ethnicity).to eq([ "Caucasian" ])
    end

    it 'returns empty array when ethnicity is not present' do
      match = build(:match)
      match.external_data["properties"]["ethnicity"] = nil
      expect(match.ethnicity).to eq([])
    end
  end
end
