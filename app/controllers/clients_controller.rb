class ClientsController < ApplicationController
  include Pagination

  def index
    base_scope = Client.includes(:clientable)
                      .joins("LEFT JOIN people ON clients.clientable_id = people.id AND clients.clientable_type = 'Person'")
                      .joins("LEFT JOIN companies ON clients.clientable_id = companies.id AND clients.clientable_type = 'Company'")
                      .order(Arel.sql("COALESCE(people.last_name, companies.name) ASC"))
    filtered_scope = base_scope.where(clientable_type: (params[:nature] || "person").capitalize)
    @clients = paginate(filtered_scope)
  end

  def show
    @client = Client.includes(clientable: { screenings: :sanctions }).find(params[:id])
    @screening = Screening.new(screenable: @client)
  end

  def new
    @client = Client.new
    @client.build_clientable(type: params[:nature] || "person")
  end

  def create
    clientable_type = client_params[:clientable_type].classify
    clientable = clientable_type.constantize.new(client_params[:clientable_attributes])

    @client = Client.new(
      clientable: clientable,
      clientable_type: clientable_type
    )

    # Only process risk factors if they're present in the params
    if client_params[:risk_factors_attributes].present?
      @client.risk_factors_attributes = client_params[:risk_factors_attributes].values.map do |attrs|
        next if attrs[:identified_at].blank?
        {
          category: attrs[:category],
          identifier: attrs[:identifier],
          identified_at: Time.current
        }
      end.compact
    end

    if @client.save
      redirect_to @client, notice: "Client was successfully created."
    else
      @client.build_clientable(type: params[:nature] || "person") unless @client.clientable
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @client = Client.includes(clientable: { screenings: :sanctions }).find(params[:id])
  end

  def update
    @client = Client.includes(:risk_factors).find(params[:id])

    ActiveRecord::Base.transaction do
      # Update PEP status if present
      if client_params[:clientable_attributes]
        @client.clientable.update!(client_params[:clientable_attributes])
      end

      # Update risk factors
      if client_params[:risk_factors_attributes]
        # Get all submitted risk factor identifiers
        submitted_risk_factors = client_params[:risk_factors_attributes].values.map do |attrs|
          [ attrs[:category], attrs[:identifier], attrs[:identified_at].present? ]
        end

        # Delete unchecked risk factors
        @client.risk_factors.each do |risk_factor|
          matching_submission = submitted_risk_factors.find { |category, identifier, checked|
            category == risk_factor.category && identifier == risk_factor.identifier
          }

          if matching_submission.nil? || !matching_submission[2] # If not found or unchecked
            risk_factor.destroy
          end
        end

        # Create newly checked risk factors
        client_params[:risk_factors_attributes].values.each do |attrs|
          next if attrs[:identified_at].blank?

          @client.risk_factors.find_or_create_by!(
            category: attrs[:category],
            identifier: attrs[:identifier]
          ) do |rf|
            rf.identified_at = Time.current
          end
        end
      end

      redirect_to @client, notice: "Client was successfully updated."
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  private

  def client_params
    params.require(:client).permit(
      :id,
      :clientable_type,
      clientable_attributes: [
        :id,
        :name,
        :first_name,
        :last_name,
        :nationality,
        :country,
        :country_of_birth,
        :country_of_residence,
        :country_of_profession,
        :profession,
        :pep
      ],
      risk_factors_attributes: [
        :id,
        :category,
        :identifier,
        :identified_at
      ]
    )
  end
end
