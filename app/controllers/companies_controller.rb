class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update destroy ]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html do
          if @company.client?
            redirect_to Client.find_by(clientable: @company), notice: "Company updated successfully"
          else
            redirect_to @company, notice: "Company updated successfully"
          end
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def show
    @company = Company.find(params[:id])
  end

  def destroy
    @company.destroy!

    respond_to do |format|
      format.html { redirect_to companies_path, status: :see_other, notice: "Company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :country)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end
