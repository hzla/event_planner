class Api::V1::EventsController < ApplicationController

	include SessionsHelper
	include ApplicationHelper
	skip_before_filter  :verify_authenticity_token
	skip_before_filter :require_login

	def index
		events = Event.all
		new_params = extract_non_model_attributes(params, Event, true)
		if new_params
			events = Event.where(new_params)
		end
		render json: api_response("events", to_array_of_hashes(events))
	end

	def show
		begin 
			event = Event.find(params[:id])
			if params[:show_metadata] == "true"
				full_metadata_event = event.as_json
				active_record_polls = event.polls
				full_metadata_event["polls"] = active_record_polls.as_json
				full_metadata_event["polls"].each_with_index do |poll, i|
					poll["choices"] = active_record_polls[i].choices.as_json
				end
				user = User.find(event.user_id)
				render json: api_response("getEvent", {event: full_metadata_event, user: user.as_json }) and return
			else
				render json: api_response("getEvent", to_hash(event))
			end
		rescue
			render json: api_error("getEvent", "404", "Record not found")
		end
	end

	def create
		if !params["record_id"]
			event = Event.create extract_non_model_attributes(params, Event)
			render json: api_response("createEvent", to_hash(event)) and return
		else
			event = Event.find params["record_id"]
			event.update_attributes extract_non_model_attributes(params, Event)
			render json: api_response("updateEvent", to_hash(event))
		end
	end

	def update
		begin
			event = Event.find params[:id]
			event.update_attributes extract_non_model_attributes(params, Event)
			render json: api_response("updateEvent", to_hash(event))
		rescue
			render json: api_error("updateEvent", "404", "Record not Found")
		end
	end

	def delete
		begin 
			event = Event.find params["record_id"]
			event.destroy
			render json: api_response("deleteEvent", to_hash(event))
		rescue
			render json: api_error("deleteEvent", "404", "Record not Found")
		end
	end


end
