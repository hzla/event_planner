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
				users = event.users
				render json: api_response("getEvent", {event: full_metadata_event, users: to_array_of_hashes(users) }) and return
			else
				render json: api_response("getEvent", to_hash(event))
			end
		rescue
			render json: api_error("getEvent", "404", "Record not found")
		end
	end

	def create
		if !params["record_id"]
			if !params["event"] 
				event = Event.create extract_non_model_attributes(params, Event)
				render json: api_response("createEvent", to_hash(event))
			else
				polls = []
				choices = []
				event = Event.create params["event"]
				params["polls"].each do |poll_params|
					poll = Poll.create poll_params
					event.polls << poll
					polls << poll
					params["choices"].each do |choice_params|
						choice = Choice.create choice_params
						poll.choices << choice
						choices << choice
					end
				end
				result = {event: to_hash(event), polls: to_array_of_hashes(polls), choices: to_array_of_hashes(choices)}
				render json: api_response("createEventWithMetadata", result)
			end
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

	def activate
		begin
			event = Event.find params["record_id"]
			created_users = event.activate_polls
			render json: api_response("activateEvent", {event: to_hash(event), created_users: created_users} )
		rescue
			render json: api_error("activateEvent", "404", "Record not Found")
		end
	end

end
