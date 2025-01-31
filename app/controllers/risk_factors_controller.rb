class RiskFactorsController < ApplicationController
  before_action :set_person

  def index
    @risk_factors = @person.risk_factors
  end

  def toggle
    @risk_factor = @person.risk_factors.find(params[:id])
    @risk_factor.update(identified_at: @risk_factor.identified_at? ? nil : Time.current)
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  end
end
