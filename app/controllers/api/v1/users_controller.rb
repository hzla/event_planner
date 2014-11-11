class Api::V1::UsersController < ApplicationController
	
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login

	def index
		users = User.all
		new_params =  extract_non_model_attributes(params, User, true)
		if new_params
			users = User.where(new_params)
		end
		render json: api_response("users", to_array_of_hashes(users))
	end

	def show
		begin 
			user = User.find params[:id]
			render json: api_response("getUser", user.to_hash)
		rescue
			render json: api_error("getUser", "404", "Record not Found")
		end
	end

	def update
		begin 
			user = User.find params[:id]
			user.update_attributes extract_non_model_attributes(params, User)
			render json: api_response("updateUser", user.to_hash)
		rescue
			render json: api_error("updateUser", "404", "Record not Found")
		end
	end

	def create 
		if !params["record_id"]
			user = User.create extract_non_model_attributes(params, User)
			render json: api_response("createUser", user.to_hash) and return
		else
			user = User.find params["record_id"]
			user.update_attributes extract_non_model_attributes(params, User)
			render json: api_response("updateUser", user.to_hash) and return
		end
	end

end