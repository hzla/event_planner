class UsersController < ApplicationController
	
	include SessionsHelper

	def dashboard
		@event = Event.new
		@events = current_user.events.where(status: "activated").uniq
		@tutorial = @events.empty?
		if params[:code]
			session[:user_id] = params[:monkey].to_i
		end
	end

end