class PagesController < ApplicationController
  def dashboard
    @client_risk_matrix = calculate_client_risk_matrix
    @products_risk_matrix = calculate_products_risk_matrix
    @distribution_risk_matrix = calculate_distribution_risk_matrix
    @transaction_risk_matrix = calculate_transaction_risk_matrix
    @country_risk_matrix = calculate_country_risk_matrix
  end

  private

  def calculate_client_risk_matrix
    matrix = Hash.new
    clients = ClientRiskSummary.all
    total_clients = clients.count.to_f

    [ :high, :medium, :low ].each do |probability_level|
      [ :low, :medium, :high ].each do |impact_level|
        clients_in_cell = clients.count do |client|
          impact = case client.client_risk_score
          when 0..40 then :low
          when 41..70 then :medium
          else :high
          end

          clients_at_level = clients.count { |c| c.client_risk_score >= client.client_risk_score }
          probability_percentage = (clients_at_level / total_clients) * 100

          probability = case probability_percentage
          when 0..33 then :low
          when 34..66 then :medium
          else :high
          end

          impact == impact_level && probability == probability_level
        end

        key = "#{probability_level}_#{impact_level}"

        matrix[key] = {
          percentage: ((clients_in_cell / total_clients) * 100).round,
          count: clients_in_cell,
          total: clients.count
        }
      end
    end

    matrix
  end

  def calculate_products_risk_matrix
    matrix = Hash.new
    clients = ClientRiskSummary.all
    total_clients = clients.count.to_f

    clients.each do |client|
      impact = case client.products_and_services_risk_score
      when 0..40 then :low
      when 41..70 then :medium
      else :high
      end

      clients_at_this_level = clients.count { |c| c.products_and_services_risk_score >= client.products_and_services_risk_score }
      probability_percentage = (clients_at_this_level / total_clients) * 100

      probability = case probability_percentage
      when 0..33 then :low
      when 34..66 then :medium
      else :high
      end

      key = "#{probability}_#{impact}"

      matrix[key] = {
        percentage: probability_percentage.round,
        count: clients_at_this_level,
        total: clients.count
      }
    end

    matrix
  end

  def calculate_distribution_risk_matrix
    matrix = Hash.new
    clients = ClientRiskSummary.all
    total_clients = clients.count.to_f

    clients.each do |client|
      impact = case client.distribution_channel_risk_score
      when 0..40 then :low
      when 41..70 then :medium
      else :high
      end

      clients_at_this_level = clients.count { |c| c.distribution_channel_risk_score >= client.distribution_channel_risk_score }
      probability_percentage = (clients_at_this_level / total_clients) * 100

      probability = case probability_percentage
      when 0..33 then :low
      when 34..66 then :medium
      else :high
      end

      key = "#{probability}_#{impact}"

      matrix[key] = {
        percentage: probability_percentage.round,
        count: clients_at_this_level,
        total: clients.count
      }
    end

    matrix
  end

  def calculate_transaction_risk_matrix
    matrix = Hash.new
    clients = ClientRiskSummary.all
    total_clients = clients.count.to_f

    clients.each do |client|
      impact = case client.transaction_risk_score
      when 0..40 then :low
      when 41..70 then :medium
      else :high
      end

      clients_at_this_level = clients.count { |c| c.transaction_risk_score >= client.transaction_risk_score }
      probability_percentage = (clients_at_this_level / total_clients) * 100

      probability = case probability_percentage
      when 0..33 then :low
      when 34..66 then :medium
      else :high
      end

      key = "#{probability}_#{impact}"

      matrix[key] = {
        percentage: probability_percentage.round,
        count: clients_at_this_level,
        total: clients.count
      }
    end

    matrix
  end

  def calculate_country_risk_matrix
    matrix = Hash.new
    clients = ClientRiskSummary.all
    total_clients = clients.count.to_f

    clients.each do |client|
      impact = case client.country_risk_score
      when 0..40 then :low
      when 41..70 then :medium
      else :high
      end

      clients_at_this_level = clients.count { |c| c.country_risk_score >= client.country_risk_score }
      probability_percentage = (clients_at_this_level / total_clients) * 100

      probability = case probability_percentage
      when 0..33 then :low
      when 34..67 then :medium
      else :high
      end

      key = "#{probability}_#{impact}"

      matrix[key] = {
        percentage: probability_percentage.round,
        count: clients_at_this_level,
        total: clients.count
      }
    end

    matrix
  end
end
