class UsersController < ApplicationController
	
	include SessionsHelper

	def dashboard
		@event = Event.new
	end

end