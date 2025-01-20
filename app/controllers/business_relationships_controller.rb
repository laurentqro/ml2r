class BusinessRelationshipsController < ApplicationController
  def index
    @clients = BusinessRelationship.all
  end

  def show
    @client = BusinessRelationship.find(params[:id])
  end
end
