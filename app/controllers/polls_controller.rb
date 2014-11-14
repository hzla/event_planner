class PollsController < ApplicationController
	
	include SessionsHelper
	skip_before_action :require_login, only: "show"
	before_filter :check_event_ownership


	def create
		email_list = params[:email_list].split(", ")
		@event = Event.find(@event_id)
		@event.polls.destroy_all
		email_list.each do |email|
			Poll.create email: email, event_id: @event_id
		end
		@event.create_threshold
		redirect_to opentable_path(event_id: @event_id)
	end

	def show
		@poll = Poll.find params[:id]
		@event = @poll.event
		if params[:code] != @poll.url.split("?code=").last
			redirect_to root_path and return
		end
		session[:user_id] = nil
		user = User.where(activation: @poll.code).first
		session[:user_id] = user.id
		session[:user_exists] = true
		session[:poll_url] = @poll.url
		@is_owner = (current_user.id == @event.user_id)
		@fb_connected = !!current_user.profile_pic_url
		@poll.update_attributes user_id: user.id
		@code = params[:code]
	end

	def take
		@poll = Poll.find(params[:id])
		@event = @poll.event
		if params[:code] != @poll.url.split("?code=").last
			redirect_to root_path and return
		end
		@choices = @poll.choices
	end

	def delete
		poll = Poll.find params[:id]
		outing =  Outing.where(user_id: current_user.id, event_id: poll.event.id)
		outing.first.destroy if !outing.empty?
		poll.destroy
		redirect_to root_path
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