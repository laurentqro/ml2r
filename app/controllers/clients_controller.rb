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

    if @client.save
      redirect_to @client, notice: "Client was successfully created."
    else
      @client.build_clientable(type: params[:nature] || "person") unless @client.clientable
      render :new, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(
      :clientable_type,
      clientable_attributes: [
        :first_name, :last_name, :nationality,
        :country_of_birth, :country_of_residence,
        :country_of_profession, :profession, :pep,
        identification_documents_attributes: [
          :id, :document_type, :number,
          :expiration_date, :is_copy, :_destroy
        ]
      ]
    )
  end
end
