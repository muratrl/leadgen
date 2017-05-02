class ProspectsController < ApplicationController
  def show
    @prospect=Prospect.find(params[:id])
    @rental=Rental.where(prospect_user_id: params[:id])[0]
    @linkedin=Linkedin.where(prospect_user_id: params[:id])[0]
  end
end
