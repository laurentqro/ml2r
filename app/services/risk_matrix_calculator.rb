class RiskMatrixCalculator
  IMPACT_RANGES = {
    low: 0..40,
    medium: 41..70,
    high: 71..
  }.freeze

  def self.calculate(score_field)
    new(score_field).calculate
  end

  def initialize(score_field)
    @score_field = score_field
    @total_clients = ClientRiskSummary.count.to_f
  end

  def calculate
    matrix = Array.new(3) { Array.new(3) }

    [:low, :medium, :high].each_with_index do |impact, impact_index|
      range = IMPACT_RANGES[impact]
      client_count = ClientRiskSummary.where(@score_field => range).count
      percentage = calculate_percentage(client_count)

      matrix[impact_index][calculate_exposure_index(percentage)] = {
        percentage: percentage,
        count: client_count,
        total: @total_clients.to_i
      }
    end

    matrix
  end

  private

  def calculate_percentage(count)
    (count / @total_clients * 100).round(2)
  end

  def calculate_exposure_index(percentage)
    case percentage
    when 0..33 then 2  # low
    when 34..66 then 1 # medium
    else 0             # high
    end
  end
end 