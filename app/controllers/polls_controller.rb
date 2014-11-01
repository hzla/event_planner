class PollsController < ApplicationController
	
	include SessionsHelper
	skip_before_action :require_login, only: "show"
	before_filter :check_event_ownership


	def create
		email_list = params[:email_list].split(", ")
		email_list << current_user.email
		email_list.each do |email|
			Poll.create email: email, event_id: @event_id
		end
		redirect_to services_path(event_id: @event_id)
	end

	def show
		@poll = Poll.find params[:id]
		if params[:code] != @poll.url.split("?code=").last
			redirect_to root_path and return
		end
		@code = params[:code]
	end

	def take
		@poll = Poll.find(params[:id])
		if params[:code] != @poll.url.split("?code=").last
			p params[:code]
			p @poll.url.split("?code=").last
			redirect_to root_path and return
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