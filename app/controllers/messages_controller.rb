class MessagesController < ApplicationController

	def create
		message = Message.create!(m_params)
		redirect_to root_path
	end

	private
	  def m_params
    	params.require(:message).permit(:content, :user_id, :image, :status)
  	end
end
