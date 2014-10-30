class PollsController < ApplicationController
	
	include SessionsHelper
	before_filter :check_event_ownership


	def create
		email_list = params[:email_list].split(", ")
		email_list.each do |email|
			Poll.create email: email, event_id: @event_id
		end
		redirect_to services_path(event_id: @event_id)
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