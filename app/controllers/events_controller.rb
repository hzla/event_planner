class EventsController < ApplicationController

	include SessionsHelper

	def create
		@event = Event.create params[:event]
		current_user.events << @event
		redirect_to invite_friends_path(event_id: @event.id)
	end

	def activate
		@event = Event.find(params[:id])
		@event.activate_polls
		@poll = @event.polls.where(email: current_user.email).first
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
	end

end
