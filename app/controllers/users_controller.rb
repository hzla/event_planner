class UsersController < ApplicationController
	
	include SessionsHelpere

	def dashboard
		@event = Event.new
		@events = current_user.events.where(status: "activated")
	end

end