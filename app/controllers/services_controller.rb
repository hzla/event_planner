class ServicesController < ApplicationController
	
	include SessionsHelper
	before_filter :check_event_ownership

	def index
		@services = Service.all
	end

	def opentable
		if current_user.location
			location = current_user.location 
			location = location.split(',')[0]
		else
			location = nil
		end
		@options = Opentable.options location
	end

	private


	def check_event_ownership
		if params[:event_id]
			event = Event.find params[:event_id]
			if event.user_id != session[:user_id]
				redirect_to dashboard_path
			else
				@event_id = params[:event_id]
			end
		end
	end


end
