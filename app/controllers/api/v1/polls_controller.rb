class Api::V1::PollsController < ApplicationController
	
	include SessionsHelper
	skip_before_action :require_login
	skip_before_filter :verify_authenticity_token

	def create
		poll = Poll.create params[:poll]
		render json: poll.to_json
	end

	def show
		poll = Poll.find params[:id]
		if params[:show_metadata] == "true"
			full_metadata_poll = poll.as_json
			active_record_choices = poll.choices
			full_metadata_poll["choices"] = active_record_choices.as_json
			if poll.user_id
				user = User.find poll.user_id
			end
			if poll.user_id
				render json: {poll: full_metadata_poll.to_json, user: user.as_json} and return
			else
				render json: {poll: full_metadata_poll} and return
			end
		end
		render json: poll.to_json
	end

	def index
		polls = Poll.all
		if params[:poll]
			polls = Poll.where(params[:poll])
		end
		render json: polls.to_json
	end

	def update
		poll = Poll.find params[:id]
		poll.update_attribute params[:poll]
		render json: poll.to_json
	end

end