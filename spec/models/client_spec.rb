require 'rails_helper'

RSpec.describe Client do
  describe '#risk_score' do
    let(:person) do
      Person.new(
        first_name: 'John',
        last_name: 'Doe',
        country_of_residence: 'DK',    # Low risk (90)
        nationality: 'VN',             # Medium risk + greylist
        country_of_profession: 'GB',   # Low risk
        country_of_birth: 'SO',         # High risk
        profession: 'Doctor',
        pep: false
      )
    end

    let(:client) { described_class.new(clientable: person) }

    it 'calculates weighted risk score from all countries' do
      # Expected calculations:
      # DK (residence):    10 * 40 = 400     (100 - 90 = 10)
      # VN (nationality):  118 * 35 = 4130   ((100 - 41) * 2 = 118)
      # GB (profession):   29 * 15 = 435     (100 - 71 = 29)
      # SO (birth):        89 * 10 = 890     (100 - 11 = 89)
      # Total weight: 100
      # Expected country score: (400 + 4130 + 435 + 890) / 100 = 5855 / 100 = 58.55 ≈ 59

      expect(client.country_risk_score).to eq(59)
    end

    it 'returns infinity for blacklisted countries' do
      person.nationality = 'IR' # Iran - blacklisted
      expect(client.country_risk_score).to eq(Float::INFINITY)
    end

    it 'handles missing country data' do
      person.country_of_residence = nil
      person.nationality = nil

      risk_score = client.country_risk_score

      # Only profession and birth country present
      # GB (profession):   29 * 15 = 435
      # SO (birth):        89 * 10 = 890
      # Total weight: 25
      # Expected: (435 + 890) / 25 = 53

      expect(risk_score).to eq(53)
    end

    it 'returns 0 when no data is present' do
      person.country_of_residence = nil
      person.nationality = nil
      person.country_of_profession = nil
      person.country_of_birth = nil

      expect(client.country_risk_score).to eq(0)
    end

    context "with company client" do
      let(:company) do
        Company.new(
          country: 'GB'  # Low risk
        )
      end

      let(:client) { described_class.new(clientable: company) }

      it 'calculates risk score from company country' do
        risk_score = client.country_risk_score

        # Expected calculations:
        # GB: 29 * 100 = 2900  (100 - 71 = 29)
        # Total weight: 100
        # Expected score: 2900 / 100 = 29

        expect(risk_score).to eq(29)
      end

      it 'returns infinity for blacklisted company country' do
        company.country = 'IR' # Iran - blacklisted
        expect(client.country_risk_score).to eq(Float::INFINITY)
      end

      it 'returns 0 when no country data is present' do
        company.country = nil
        expect(client.country_risk_score).to eq(0)
      end
    end

    context 'with risk factors' do
      before do
        client.save!

        create(:person_client_risk_factor_definition, identifier: :rushed_transactions, score: 10)
        create(:person_products_and_services_risk_factor_definition, identifier: :new_build_sale, score: 15)

        create(:risk_factor,
          client: client,
          category: :products_and_services_risk,
          identifier: :new_build_sale
        )

        create(:risk_factor,
          client: client,
          category: :client_risk,
          identifier: :rushed_transactions
        )
      end

      it 'calculates combined risk score' do
        # Country score: 59
        # Risk factors score: 15 + 10 = 25
        # Final score: (59 + 25) = 84

        expect(client.total_risk_score).to eq(84)
      end
    end
  end

  describe "validations" do
    let(:person) do
      Person.new(
        first_name: 'John',
        last_name: 'Doe',
        country_of_residence: 'DK',
        nationality: 'KP',  # North Korea - blacklisted
        country_of_profession: 'GB',
        country_of_birth: 'FR',
        profession: 'Doctor',
        pep: true
      )
    end

    let(:client) { described_class.new(clientable: person) }

    it "is invalid if client has ties to blacklisted countries" do
      expect(client).not_to be_valid
      expect(client.errors[:base]).to include("Cannot onboard clients with ties to FATF blacklisted countries")
    end

    it "is valid without blacklisted countries" do
      person.nationality = 'GB'
      expect(client).to be_valid
    end
  end

  describe "risk score methods" do
    let(:client) { create(:client, clientable: create(:person)) }

    describe "#total_risk_factors_score" do
      it "sums up scores from all risk categories" do
        create(:person_client_risk_factor_definition, identifier: :rushed_transactions, score: 30)
        create(:person_client_risk_factor_definition, identifier: :trust_or_foundation, score: 25)

        create(:risk_factor,
          client: client,
          category: :client_risk,
          identifier: :rushed_transactions
        )

        create(:risk_factor,
          client: client,
          category: :client_risk,
          identifier: :trust_or_foundation
        )

        expect(client.total_risk_factors_score).to eq(55)
      end
    end

    describe "#category_risk_score" do
      it "calculates score based on risk factor definitions" do
        create(:person_client_risk_factor_definition, identifier: :rushed_transactions, score: 30)
        create(:person_client_risk_factor_definition, identifier: :trust_or_foundation, score: 25)

        create(:risk_factor,
          client: client,
          category: :client_risk,
          identifier: :rushed_transactions
        )

        create(:risk_factor,
          client: client,
          category: :client_risk,
          identifier: :trust_or_foundation
        )

        expect(client.category_risk_score(:client_risk)).to eq(55)
      end
    end

    describe "individual category risk scores" do
      before do
        allow(client).to receive(:category_risk_score).and_return(0)
      end

      it "delegates to category_risk_score for client_risk_score" do
        expect(client).to receive(:category_risk_score).with(:client_risk)
        client.client_risk_score
      end

      it "delegates to category_risk_score for products_and_services_risk_score" do
        expect(client).to receive(:category_risk_score).with(:products_and_services_risk)
        client.products_and_services_risk_score
      end

      it "delegates to category_risk_score for distribution_channel_risk_score" do
        expect(client).to receive(:category_risk_score).with(:distribution_channel_risk)
        client.distribution_channel_risk_score
      end

      it "delegates to category_risk_score for transaction_risk_score" do
        expect(client).to receive(:category_risk_score).with(:transaction_risk)
        client.transaction_risk_score
      end
    end
  end

  describe "scopes" do
    before do
      # Create test data for scopes
      @sanctioned_person = create(:person, sanctioned: true)
      @sanctioned_company = create(:company, sanctioned: true)
      @pep_person = create(:person, pep: true)
      @regular_person = create(:person, sanctioned: false, pep: false)
      @regular_company = create(:company, sanctioned: false)

      @sanctioned_person_client = create(:client, clientable: @sanctioned_person)
      @sanctioned_company_client = create(:client, clientable: @sanctioned_company)
      @pep_client = create(:client, clientable: @pep_person)
      @regular_person_client = create(:client, clientable: @regular_person)
      @regular_company_client = create(:client, clientable: @regular_company)
    end

    describe ".clear" do
      it "returns clients without sanctions" do
        clear_clients = Client.clear

        expect(clear_clients).to include(@regular_person_client, @regular_company_client, @pep_client)
        expect(clear_clients).not_to include(@sanctioned_person_client, @sanctioned_company_client)
      end
    end

    describe ".sanctioned" do
      it "returns clients with sanctions" do
        sanctioned_clients = Client.sanctioned

        expect(sanctioned_clients).to include(@sanctioned_person_client, @sanctioned_company_client)
        expect(sanctioned_clients).not_to include(@regular_person_client, @regular_company_client, @pep_client)
      end
    end

    describe ".pep" do
      it "returns clients who are politically exposed persons" do
        pep_clients = Client.pep
        expect(pep_clients).to include(@pep_client)
        expect(pep_clients).not_to include(@regular_person_client, @regular_company_client,
                                          @sanctioned_person_client, @sanctioned_company_client)
      end
    end
  end
end
