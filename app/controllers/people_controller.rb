class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people/1 or /people/1.json
  def show
    @screening = Screening.new(screenable: @person)
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        ActiveRecord::Base.transaction do
          screen_person!
          check_adverse_media!
          create_client!
        end

        format.html { redirect_to @person, notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html do
          if @person.client?
            redirect_to Client.find_by(clientable: @person), notice: "Person was successfully updated."
          else
            redirect_to @person, notice: "Person was successfully updated."
          end
        end
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to prospects_path, status: :see_other, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(
        :first_name,
        :last_name,
        :nationality,
        :country_of_birth,
        :country_of_residence,
        :country_of_profession,
        :profession,
        :date_of_birth,
        :pep,
        :sanctioned,
        identification_documents_attributes: [
          :id,
          :document_type,
          :number,
          :expiration_date,
          :is_copy,
          :_destroy
        ]
      )
    end

    def screen_person!
      screening = Screening.new(screenable: @person, query: @person.display_name.downcase)
      if screening.save!
        screening.run
      end
    end

    def check_adverse_media!
      adverse_media_check = AdverseMediaCheck.new(adverse_media_checkable: @person)
      if adverse_media_check.save!
        AdverseMediaCheckJob.perform_later(adverse_media_check.id)
      end
    end

    def create_client!
      Client.create!(clientable: @person)
    end
end
