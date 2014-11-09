class UsersController < ApplicationController
	
	include SessionsHelper

	def dashboard
		@event = Event.new
		@events = current_user.events.where(status: "activated")
	end

end