class Prospect
  def self.all
    Person.where.missing(:business_relationships) + Company.where.missing(:business_relationships)
  end

  def self.people
    Person.where.missing(:business_relationships)
  end

  def self.companies
    Company.where.missing(:business_relationships)
  end

  def self.any?
    people.any? || companies.any?
  end

  def self.clear
    people.clear + companies.clear
  end

  def self.pep
    people.pep
  end

  def self.sanctioned
    people.sanctioned + companies.sanctioned
  end

  def self.with_adverse_media
    people.with_adverse_media + companies.with_adverse_media
  end
end
