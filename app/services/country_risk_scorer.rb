class CountryRiskScorer
  def self.calculate_risk_score(country_code)
    corruption_risk = 100 - perceived_corruption_index(country_code)

    case gafi_status(country_code)
    when :black then corruption_risk * 3
    when :grey then corruption_risk * 2
    else corruption_risk
    end
  end

  def self.perceived_corruption_index(country_code)
    cpi_data = load_cpi_data
    score = cpi_data[country_code]

    score || 50
  end

  def self.gafi_status(country_code)
    gafi_data = load_gafi_data
    gafi_data[country_code]
  end

  def self.blacklisted?(country_code)
    gafi_status(country_code) == :black
  end

  private

  def self.load_cpi_data
    @cpi_data ||= begin
      csv_path = Rails.root.join("lib", "data", "cpi.csv")
      CSV.read(csv_path, headers: true).each_with_object({}) do |row, hash|
        hash[row["Country"]] = row["Score"].to_i
      end
    end
  end

  def self.load_gafi_data
    @gafi_data ||= begin
      csv_path = Rails.root.join("lib", "data", "gafi.csv")
      CSV.read(csv_path, headers: true).each_with_object({}) do |row, hash|
        hash[row["Country"]] = row["Status"].downcase.to_sym
      end
    end
  end
end
