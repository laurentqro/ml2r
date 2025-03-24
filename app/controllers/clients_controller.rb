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

    if params[:query].present?
      search_term = "%#{params[:query].downcase}%"
      filtered_scope = filtered_scope.where("LOWER(display_name) LIKE ?", search_term)
    end

    @clear_count = Client.clear.count
    @pep_count = Client.pep.count
    @sanctioned_count = Client.sanctioned.count
    @with_adverse_media_count = Client.with_adverse_media.count

    @client_risk_summaries = paginate(filtered_scope)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @client = Client.includes(clientable: :screenings).find(params[:id])
    @clientable = @client.clientable
    @screening = Screening.new(screenable: @client)
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: "Client was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit_notes
    @client = Client.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("note", partial: "notes/edit", locals: { client: @client })
      end
    end
  end

  def update_notes
    @client = Client.find(params[:id])

    if @client.update(notes: params[:client][:notes])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "note",
              partial: "notes/show",
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
      :clientable_type,
      :clientable_id,
      :notes
    )
  end
end
