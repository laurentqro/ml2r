class ClientsController < ApplicationController
  include Pagination
  include ClientsHelper

  def index
    base_scope = ClientRiskSummary.order(sort_column => sort_direction)

    filtered_scope = if params[:nature].present?
      base_scope.where(clientable_type: params[:nature].capitalize)
    else
      base_scope.where(clientable_type: "Person")
    end

    @clients = paginate(filtered_scope)
  end

  def show
    @client = Client.includes(clientable: :screenings).find(params[:id])
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
      risk_factors = client_params[:risk_factors_attributes].values.map do |attrs|
        next if attrs[:identified_at].blank?

        @client.risk_factor_class.new(
          client: @client,
          category: attrs[:category],
          identifier: attrs[:identifier],
          identified_at: Time.current
        )
      end.compact

      # Assign the risk factors to the correct association
      if @client.clientable_type == "Person"
        @client.person_risk_factors = risk_factors
      else
        @client.company_risk_factors = risk_factors
      end
    end

    if @client.save
      RiskScoresheet.create_for_client!(@client)
      redirect_to @client, notice: "Client was successfully created."
    else
      @client.build_clientable(type: params[:nature] || "person") unless @client.clientable
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @client = Client.includes(clientable: :screenings).find(params[:id])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("kyc_note", partial: "clients/kyc_notes_edit", locals: { client: @client }) }
    end
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
        @client.risk_factor_class.where(client: @client).each do |risk_factor|
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

          @client.risk_factor_class.find_or_create_by!(
            client: @client,
            category: attrs[:category],
            identifier: attrs[:identifier]
          ) do |rf|
            rf.identified_at = Time.current
          end
        end

        RiskScoresheet.create_for_client!(@client)
      end

      redirect_to @client, notice: "Client was successfully updated."
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def update_notes
    @client = Client.find(params[:id])

    if @client.update(notes: params[:client][:notes])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "kyc_note",
              partial: "clients/kyc_notes_show",
              locals: { client: @client }
            )
          ]
        end
      end
    end
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
        :pep,
        :notes,
        identification_documents_attributes: [
          :id,
          :document_type,
          :number,
          :expiration_date,
          :is_copy
        ]
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
