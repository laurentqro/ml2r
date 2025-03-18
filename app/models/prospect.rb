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
    Person.any? || Company.any?
  end
end
