class PagesController < ApplicationController
  def dashboard
    @client_risk_matrix = calculate_client_risk_matrix
    @products_risk_matrix = calculate_products_risk_matrix
    @distribution_risk_matrix = calculate_distribution_risk_matrix
    @transaction_risk_matrix = calculate_transaction_risk_matrix
    @country_risk_matrix = calculate_country_risk_matrix
    @total_risk_matrix = calculate_total_risk_matrix
  end

  private

  def calculate_client_risk_matrix
    impact_ranges = {
      low: 0..40,
      medium: 41..70,
      high: 71..
    }

    total_clients = ClientRiskSummary.count.to_f

    # Create a 3x3 array where each element is a hash with the cell data
    matrix = Array.new(3) { Array.new(3) }

    [ :low, :medium, :high ].each_with_index do |impact, impact_index|
      range = impact_ranges[impact]
      client_count = ClientRiskSummary.where(client_risk_score: range).count
      percentage = (client_count / total_clients * 100).round

      # Determine exposure level based on percentage
      exposure = case percentage
      when 0..33 then :low
      when 34..66 then :medium
      else :high
      end

      # Convert exposure to index (reverse order since view displays high->low)
      exposure_index = case exposure
      when :high then 0
      when :medium then 1
      when :low then 2
      end

      # Store the data in the correct cell
      matrix[impact_index][exposure_index] = {
        percentage: percentage,
        count: client_count,
        total: total_clients.to_i
      }
    end

    matrix
  end

  def calculate_products_risk_matrix
    impact_ranges = {
      low: 0..40,
      medium: 41..70,
      high: 71..
    }

    total_clients = ClientRiskSummary.count.to_f
    matrix = Array.new(3) { Array.new(3) }

    [ :low, :medium, :high ].each_with_index do |impact, impact_index|
      range = impact_ranges[impact]
      client_count = ClientRiskSummary.where(products_and_services_risk_score: range).count
      percentage = (client_count / total_clients * 100).round

      exposure_index = case percentage
      when 0..33 then 2  # low
      when 34..66 then 1 # medium
      else 0             # high
      end

      matrix[impact_index][exposure_index] = {
        percentage: percentage,
        count: client_count,
        total: total_clients.to_i
      }
    end

    matrix
  end

  def calculate_distribution_risk_matrix
    impact_ranges = {
      low: 0..40,
      medium: 41..70,
      high: 71..
    }

    total_clients = ClientRiskSummary.count.to_f
    matrix = Array.new(3) { Array.new(3) }

    [ :low, :medium, :high ].each_with_index do |impact, impact_index|
      range = impact_ranges[impact]
      client_count = ClientRiskSummary.where(distribution_channel_risk_score: range).count
      percentage = (client_count / total_clients * 100).round

      exposure_index = case percentage
      when 0..33 then 2  # low
      when 34..66 then 1 # medium
      else 0             # high
      end

      matrix[impact_index][exposure_index] = {
        percentage: percentage,
        count: client_count,
        total: total_clients.to_i
      }
    end

    puts "### DISTRIBUTION MATRIX ###"
    puts matrix.inspect

    matrix
  end

  def calculate_transaction_risk_matrix
    impact_ranges = {
      low: 0..40,
      medium: 41..70,
      high: 71..
    }

    total_clients = ClientRiskSummary.count.to_f
    matrix = Array.new(3) { Array.new(3) }

    [ :low, :medium, :high ].each_with_index do |impact, impact_index|
      range = impact_ranges[impact]
      client_count = ClientRiskSummary.where(transaction_risk_score: range).count
      percentage = (client_count / total_clients * 100).round

      exposure_index = case percentage
      when 0..33 then 2  # low
      when 34..66 then 1 # medium
      else 0             # high
      end

      matrix[impact_index][exposure_index] = {
        percentage: percentage,
        count: client_count,
        total: total_clients.to_i
      }
    end

    matrix
  end

  def calculate_country_risk_matrix
    impact_ranges = {
      low: 0..40,
      medium: 41..70,
      high: 71..
    }

    total_clients = ClientRiskSummary.count.to_f
    matrix = Array.new(3) { Array.new(3) }

    [ :low, :medium, :high ].each_with_index do |impact, impact_index|
      range = impact_ranges[impact]
      client_count = ClientRiskSummary.where(country_risk_score: range).count
      percentage = (client_count / total_clients * 100).round

      exposure_index = case percentage
      when 0..33 then 2  # low
      when 34..66 then 1 # medium
      else 0             # high
      end

      matrix[impact_index][exposure_index] = {
        percentage: percentage,
        count: client_count,
        total: total_clients.to_i
      }
    end

    matrix
  end

  def calculate_total_risk_matrix
    impact_ranges = {
      low: 0..40,
      medium: 41..70,
      high: 71..
    }

    total_clients = ClientRiskSummary.count.to_f
    matrix = Array.new(3) { Array.new(3) }

    [ :low, :medium, :high ].each_with_index do |impact, impact_index|
      range = impact_ranges[impact]
      client_count = ClientRiskSummary.where(total_risk_score: range).count
      percentage = (client_count / total_clients * 100).round

      exposure_index = case percentage
      when 0..33 then 2  # low
      when 34..66 then 1 # medium
      else 0             # high
      end

      matrix[impact_index][exposure_index] = {
        percentage: percentage,
        count: client_count,
        total: total_clients.to_i
      }
    end

    matrix
  end
end
