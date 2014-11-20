class PollsController < ApplicationController

	include SessionsHelper
	skip_before_action :require_login, only: "show"
	before_filter :check_event_ownership


	def show
		redirect_to take_path(code: params[:code])
	end

	def take
		@poll = Poll.find(params[:id])
		@tutorial = params[:tutorial] == "true"
		@poll.update_attributes confirmed_attending: true
		@event = @poll.event
		if params[:code] != @poll.url.split("?code=").last
			redirect_to root_path
		end
		@choices = @poll.choices
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
