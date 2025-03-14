class CompanyRelationshipsController < ApplicationController
  before_action :set_company
  before_action :set_company_relationship, only: [ :edit, :update, :destroy ]

  def index
    @company_relationships = @company.company_relationships.includes(:person)
  end

  def new
    @company_relationship = @company.company_relationships.build
  end

  def edit
    @selected_person = @company_relationship.person
  end

  def create
    @company_relationship = @company.company_relationships.build(company_relationship_params)

    @selected_person = Person.find_by(id: company_relationship_params[:person_id])

    if @company_relationship.save
      redirect_to @company, notice: "Relationship was successfully created."
    else
      render :new
    end
  end

  def update
    @selected_person = Person.find_by(id: company_relationship_params[:person_id])

    if @company_relationship.update(company_relationship_params)
      redirect_to @company, notice: "Relationship was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @company_relationship.destroy
    redirect_to @company, notice: "Relationship was successfully deleted."
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_company_relationship
    @company_relationship = @company.company_relationships.find(params[:id])
  end

  def company_relationship_params
    params.require(:company_relationship).permit(
      :person_id,
      :relationship_type,
      :ownership_percentage,
      :notes
    )
  end
end
