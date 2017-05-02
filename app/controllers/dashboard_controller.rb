class DashboardController < ApplicationController

  def index
    @prospects=Prospect.joins("RIGHT OUTER JOIN prospect_linkedin on prospect_linkedin.prospect_user_id=prospect_user.id ").paginate(:page => params[:page], :per_page => 30)
  end
end
