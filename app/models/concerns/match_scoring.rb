module MatchScoring
  extend ActiveSupport::Concern

  private

  def calculate_person_match_score(person, sanction)
    score = 0
    score += calculate_last_name_score(person.last_name, sanction.last_name)
    score += calculate_first_name_score(person.first_name, sanction.first_name)
    score += calculate_alias_score(person, sanction.alias) if sanction.alias.present?
    score
  end

  def calculate_company_match_score(company, sanction)
    score = 0
    score += calculate_company_name_score(company.name, sanction.last_name)
    score += calculate_company_alias_score(company.name, sanction.alias) if sanction.alias.present?
    score
  end

  def calculate_name_similarity(name1, name2)
    return 0 if name1.blank? || name2.blank?

    str1 = name1.downcase.strip
    str2 = name2.downcase.strip

    jaro = Amatch::Jaro.new(str1)
    levenshtein = Amatch::Levenshtein.new(str1)

    [ jaro.match(str2), 1 - (levenshtein.match(str2).to_f / [ str1.length, str2.length ].max) ].max
  end

  def calculate_last_name_score(last_name, sanction_last_name)
    similarity = calculate_name_similarity(last_name, sanction_last_name)
    case similarity
    when 1.0 then 50       # Exact match
    when 0.9..0.99 then 45 # Very close match
    when 0.8..0.89 then 40 # Close match
    when 0.7..0.79 then 30 # Similar
    when 0.6..0.69 then 20 # Somewhat similar
    else 0
    end
  end

  def calculate_first_name_score(first_name, sanction_first_name)
    return 0 if first_name.blank? || sanction_first_name.blank?

    similarity = calculate_name_similarity(first_name, sanction_first_name)
    case similarity
    when 1.0 then 30       # Exact match
    when 0.9..0.99 then 25 # Very close match
    when 0.8..0.89 then 20 # Close match
    when 0.7..0.79 then 15 # Similar
    when 0.6..0.69 then 10 # Somewhat similar
    else 0
    end
  end

  def calculate_alias_score(person, alias_text)
    return 0 if alias_text.blank?

    alias_parts = alias_text.downcase.split(/[,\s]+/)
    score = 0

    # Check for full name matches
    full_name = "#{person.first_name} #{person.last_name}".downcase
    reverse_full_name = "#{person.last_name} #{person.first_name}".downcase

    if calculate_name_similarity(alias_text.downcase, full_name) > 0.9 ||
       calculate_name_similarity(alias_text.downcase, reverse_full_name) > 0.9
      return 40 # Maximum alias score for very close full name match
    end

    # Check individual parts
    alias_parts.each do |part|
      last_name_similarity = calculate_name_similarity(person.last_name, part)
      first_name_similarity = calculate_name_similarity(person.first_name, part)

      score += case [ last_name_similarity, first_name_similarity ].max
      when 0.9..1.0 then 20 # Very close match to either name
      when 0.8..0.89 then 15 # Close match
      when 0.7..0.79 then 10 # Similar
      when 0.6..0.69 then 5  # Somewhat similar
      else 0
      end
    end

    [ score, 40 ].min # Cap the alias score at 40 points
  end

  def calculate_company_name_score(company_name, sanction_name)
    similarity = calculate_name_similarity(company_name, sanction_name)
    case similarity
    when 1.0 then 70       # Exact match
    when 0.9..0.99 then 60 # Very close match
    when 0.8..0.89 then 50 # Close match
    when 0.7..0.79 then 40 # Similar
    when 0.6..0.69 then 30 # Somewhat similar
    else 0
    end
  end

  def calculate_company_alias_score(company_name, alias_text)
    return 0 if alias_text.blank?

    similarity = calculate_name_similarity(company_name, alias_text)
    case similarity
    when 0.9..1.0 then 30  # Very close match
    when 0.8..0.89 then 25 # Close match
    when 0.7..0.79 then 20 # Similar
    when 0.6..0.69 then 15 # Somewhat similar
    else 0
    end
  end
end
