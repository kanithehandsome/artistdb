class HomeController < ApplicationController
  def top
  	if current_user.present?
	  	ids = current_user.following_ids
  		@msgs = Message.where(user_id: ids).page(params[:page]).per(20)

  		@message = Message.new
  	end
  end

  def search
  	@users = User.where("email like ?", "%#{ params["keyword"] }%").where.not(email: current_user.email)
  	render :search
  end
end
