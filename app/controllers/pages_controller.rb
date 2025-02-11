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
    matrix = Hash.new(0)
    clients = ClientRiskSummary.all
    total_clients = clients.count.to_f

    clients.each do |client|
      impact = case client.client_risk_score
              when 0..40 then :low
              when 41..70 then :medium
              else :high
              end

      # Calculate probability based on how many clients share this risk level
      clients_at_this_level = clients.count { |c| c.client_risk_score >= client.client_risk_score }
      probability_percentage = (clients_at_this_level / total_clients) * 100

      probability = case probability_percentage
                   when 0..33 then :low
                   when 34..66 then :medium
                   else :high
                   end

      matrix[[probability, impact]] += 1
    end

    matrix
  end

  def calculate_products_risk_matrix
    matrix = Hash.new(0)
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

      matrix[[probability, impact]] += 1
    end

    matrix
  end

  def calculate_distribution_risk_matrix
    matrix = Hash.new(0)
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

      matrix[[probability, impact]] += 1
    end

    matrix
  end

  def calculate_transaction_risk_matrix
    matrix = Hash.new(0)
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

      matrix[[probability, impact]] += 1
    end

    matrix
  end

  def calculate_country_risk_matrix
    matrix = Hash.new(0)
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

      matrix[[probability, impact]] += 1
    end

    matrix
  end
end
