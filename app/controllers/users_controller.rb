class UsersController < ApplicationController
	
	include SessionsHelper

	def dashboard
		p current_user
		# session[:user_id] = params[:monkey].to_i
		@event = Event.new
		@events = current_user.events.where(status: "activated").uniq
		if params[:code]
			session[:user_id] = params[:monkey].to_i
		end
	end

end