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
	end

	def show
		@event = Event.find(params[:id])
		@service = Service.find @event.service_id
		@invitee_count = @event.polls.count
		@choices = @event.polls.first.choices
	end

	def invite_friends
		@event_id = params[:event_id]
	end

end
