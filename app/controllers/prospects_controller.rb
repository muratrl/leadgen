class ProspectsController < ApplicationController
  def show
    @prospect=Prospect.find(params[:id])
    @rental=Rental.where(prospect_user_id: params[:id])[0]
    @linkedin=Linkedin.where(prospect_user_id: params[:id])[0]
  end
  def update
    updateUser=Linkedin.where(prospect_user_id:params[:id])[0]
    updateUser.email=params[:q]
    updateUser.save!
    redirect_to action: "show", id: params[:id]
  end
  def updateNotes
    updateUser=Linkedin.where(prospect_user_id:params[:id])[0]
    updateUser.notes=updateUser.notes.to_s.concat(params[:notes])
    updateUser.save!
    redirect_to action: "show", id: params[:id]
  end
end
