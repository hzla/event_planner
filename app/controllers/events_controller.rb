class EventsController < ApplicationController

	include SessionsHelper

	def create
		@event = Event.create params[:event]
		@event.users << current_user
		@event.update_attributes user_id: current_user.id
		redirect_to opentable_path(event_id: @event.id)
	end

	def update
		@event = Event.find params[:id]
		@event.update_attributes params[:event]
		redirect_to opentable_path(event_id: @event.id)
	end

	def booking_info
		@event_id = params[:event_id]
		@event = Event.find @event_id
	end

	def activate
		@event = Event.find(params[:id])
		@event.activate_polls
		@poll = @event.polls.where(email: current_user.email).first
		# @theatres = Fandango.movies
	end

	def show
		@event = Event.find(params[:id])
		@service = Service.find @event.service_id
		@invitees = @event.polls
		@invitee_count = @invitees.count
		@choices = @event.polls.first.choices
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
