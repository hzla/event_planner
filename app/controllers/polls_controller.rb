class PollsController < ApplicationController

	include SessionsHelper
	skip_before_action :require_login, only: "show"
	before_filter :check_event_ownership

	def find_or_create
		@event = Event.find params[:event_id]
		if @event.user_id == current_user.id
			poll = @event.polls.where(user_id: current_user.id).first
			redirect_to poll.url and return
		else
			poll = Poll.create event_id: @event.id, confirmed_attending: true ,email: current_user.email, user_id: current_user.id
			#REFACTOR: confirmed_attending should default to true 
			poll.choices << @event.choices
			@event.users << current_user
			redirect_to poll.url
		end
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
