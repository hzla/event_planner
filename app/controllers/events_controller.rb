class EventsController < ApplicationController

	include SessionsHelper

	def create
		@event = Event.create params[:event]
		@event.users << current_user
		@event.update_attributes user_id: current_user.id
		poll = Poll.create email: current_user.email, event_id: @event.id, user_id: current_user.id, confirmed_attending: true
		redirect_to opentable_path(event_id: @event.id)
	end

	def update
		@event = Event.find params[:id]
		@event.update_attributes params[:event]
		@event.update_times
		redirect_to opentable_path(event_id: @event.id)
	end

	def activate
		Event.find(params[:id]).update_attributes status: "activated"
		render nothing: true
	end

	def booking_info
		@event = Event.new
	end

	def route
		session[:user_id] = nil
		@event = Event.find params[:id]
		if params[:code] != @event.routing_url.split("?code=").last
			redirect_to root_path and return
		end
		@polls = @event.polls
		session[:route_poll] = true
		session[:event_id] = @event.id
	end

	def generate_poll
		event = Event.find params[:id]
		if event.user_id == current_user.id
			poll = event.polls.where(user_id: current_user.id).first
			redirect_to poll.url and return
		else
			poll = Poll.create event_id: event.id, confirmed_attending: true ,email: current_user.email, user_id: current_user.id
			poll.choices << event.choices
			event.users << current_user
			redirect_to poll.url
		end
	end

	def show
		@event = Event.find(params[:id])
		@service = Service.find @event.service_id
		@invitees = @event.polls
		@invitee_count = @invitees.count
		@choices = @event.choices
	end

	def invite_friends
		@event_id = params[:event_id]
		@event = Event.find @event_id
	end

	def results
		@event = Event.find(params[:id])
		@poll = Poll.where(event_id: params[:id], email: current_user.email).first
		@ongoing = params[:ongoing] == "true"
		@choices = @event.top_choices
		@movies = params[:movies] == "true"
	end

	

end
