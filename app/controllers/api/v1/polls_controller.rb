class Api::V1::PollsController < Api::V1::ApplicationController

  include SessionsHelper
  include ApplicationHelper
  skip_before_action :require_login
  skip_before_filter :verify_authenticity_token

  def create
    if !params["record_id"]
      poll = Poll.create extract_non_model_attributes(params, Poll)
      render json: api_response("createPoll", poll.to_hash) and return
    else
      poll = Poll.find params["record_id"]
      render json: api_response("updatePoll", pol.to_hash) and return
    end
  end


	def index
	  polls = Poll.all
		new_params = extract_non_model_attributes(params, Poll, true)
		if new_params
			polls = Poll.where extract_non_model_attributes(params, Poll, true)
		end
		render json: api_response("polls", to_array_of_hashes(polls))
	end

  def show
    begin
      poll = Poll.find params[:id]
      if params[:show_metadata] == "true"
        full_metadata_poll = poll.as_json
        active_record_choices = poll.choices
        full_metadata_poll["choices"] = active_record_choices.as_json
        if poll.user_id
          user = User.find poll.user_id
        end
        if poll.user_id
          render json: api_response("getPoll", {poll: full_metadata_poll, user: user.to_hash})
          return
        else
          render json: api_response("getPoll", {poll: full_metadata_poll})
          return
        end
      end
      render json: api_response("getPoll", poll.to_hash)
    rescue
      render json: api_error("getPoll", "404", "Record not Found")
    end
  end

  def index
    polls = Poll.all
    new_params = extract_non_model_attributes(params, Poll, true)
    if new_params
      polls = Poll.where extract_non_model_attributes(params, Poll, true)
    end
    render json: api_response("polls", to_array_of_hashes(polls))
  end

  def update
    begin
      poll = Poll.find params[:id]
      poll.update_attribute extract_non_model_attributes(params, Poll)
      render json: api_response("updatePoll", poll.to_hash)
    rescue
      render json: api_error("updatePoll", "404", "Record not Found")
    end
  end

  def delete
    begin
      poll = Poll.find params["record_id"]
      poll.destroy
      render json: api_response("deletePoll", to_hash(poll))
    rescue
      render json: api_error("deletePoll", "404", "Record not Found")
    end
  end

end
