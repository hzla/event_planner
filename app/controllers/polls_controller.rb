class PollsController < ApplicationController

	include SessionsHelper
	skip_before_action :require_login, only: "show"
	before_filter :check_event_ownership


	def create
		email_list = params[:email_list].split(", ")
		@event = Event.create(user_id: current_user.id)
		@event.polls.destroy_all
		email_list.each do |email|
			poll = Poll.create email: email, event_id: @event.id
			poll.generate_url
		end
		polls = @event.polls
		polls.where(email: current_user.email).first.update_attributes user_id: current_user.id
		Poll.where(event_id: @event.id).each do |poll|
			user = User.where(email: poll.email)
			if !user.empty?
				poll.update_attributes user_id: user.first.id
			end
		end
		redirect_to booking_info_path(event_id: @event.id)
	end

	def show
		@poll = Poll.find params[:id]
		
		if @poll.confirmed_attending
			redirect_to take_path(code: params[:code]) and return
		end

		@event = @poll.event
		if params[:code] != @poll.url.split("?code=").last
			redirect_to root_path and return
		end
		session[:user_id] = nil
		user = User.where(activation: @poll.code).first
		session[:user_id] = user.id if user
		if @poll.user_id
			session[:user_id] = @poll.user_id
		end
		session[:user_exists] = true
		session[:poll_url] = "/polls/#{@poll.id}/take?code=#{@poll.code}&tutorial=true"
		@is_owner = (current_user.id == @event.user_id)
		@fb_connected = !!current_user.profile_pic_url
		@poll.update_attributes user_id: user.id if user
		@code = params[:code]
	end

	def take
		@poll = Poll.find(params[:id])
		@tutorial = params[:tutorial] == "true"
		@poll.update_attributes confirmed_attending: true
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
