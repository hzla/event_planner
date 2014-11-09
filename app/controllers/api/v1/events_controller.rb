class Api::V1::EventsController < ApplicationController

	include SessionsHelper
	skip_before_filter  :verify_authenticity_token
	skip_before_filter :require_login

	def index
		events = Event.all
		if params[:event]
			events = Event.where(params[:event]).to_json
		end
		render json: events
	end

	def show
		event = Event.find(params[:id])
		if params[:show_metadata] == "true"
			full_metadata_event = event.as_json
			active_record_polls = event.polls
			full_metadata_event["polls"] = active_record_polls.as_json
			full_metadata_event["polls"].each_with_index do |poll, i|
				poll["choices"] = active_record_polls[i].choices.as_json
			end
			user = User.find(event.user_id)
			render json: {event: full_metadata_event, user: user.to_json }
		else
			render json: event.to_json
		end
	end

	def create
		event = Event.create params[:event]
		render json: event.to_json
	end

	def update
		event = Event.find params[:id]
		event.update_attributes params[:event]
		render json: event.to_json
	end


end
