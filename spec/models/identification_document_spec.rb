require 'rails_helper'

RSpec.describe IdentificationDocument do
  let(:person) { Person.create!(
    first_name: "John",
    last_name: "Doe",
    country_of_birth: "FR",
    country_of_residence: "FR",
    country_of_profession: "FR",
    profession: "1234",
    pep: false
  )}

  describe "validations" do
    it "is valid with valid attributes" do
      document = described_class.new(
        person: person,
        document_type: "Passport",
        number: "123456789",
        expiration_date: 1.year.from_now,
        is_copy: false
      )
      expect(document).to be_valid
    end

    it "is invalid without a document type" do
      document = described_class.new(
        person: person,
        number: "123456789",
        expiration_date: 1.year.from_now
      )
      expect(document).not_to be_valid
      expect(document.errors[:document_type]).to include("can't be blank")
    end

    it "is invalid without a number" do
      document = described_class.new(
        person: person,
        document_type: "Passport",
        expiration_date: 1.year.from_now
      )
      expect(document).not_to be_valid
      expect(document.errors[:number]).to include("can't be blank")
    end

    it "is invalid without an expiration date" do
      document = described_class.new(
        person: person,
        document_type: "Passport",
        number: "123456789"
      )
      expect(document).not_to be_valid
      expect(document.errors[:expiration_date]).to include("can't be blank")
    end

    it "is invalid with a past expiration date" do
      document = described_class.new(
        person: person,
        document_type: "Passport",
        number: "123456789",
        expiration_date: 1.day.ago
      )
      expect(document).not_to be_valid
      expect(document.errors[:expiration_date]).to include("can't be in the past")
    end
  end

  describe "associations" do
    it "belongs to a person" do
      document = described_class.new
      expect(document).to respond_to(:person)
      expect(document.build_person).to be_a(Person)
    end
  end
end
