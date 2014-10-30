class EventsController < ApplicationController
	
	include SessionsHelper

	def create
		@event = Event.create params[:poll]
		current_user.events << @event
		redirect_to invite_friends_path(event_id: @event.id)
	end

	def invite_friends
		@event_id = params[:event_id]
	end

end
