class DashboardController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  def index
    @prospects=Prospect.
    joins("RIGHT OUTER JOIN prospect_linkedin on prospect_linkedin.prospect_user_id=prospect_user.id ").
    search(params[:search]).order(sort_column + ' ' + sort_direction).
    paginate(:page => params[:page], :per_page => 150)
  end
  private
   def sort_column
     params[:sort] || "owner_1_first_name"
   end

   def sort_direction
     params[:direction] || "asc"
   end
end
