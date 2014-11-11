class Api::V1::UsersController < ApplicationController
	
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login

	def index
		users = User.all
		if params
			users = User.where(extract_non_model_attributes(params, User, true))
		end
		render json: api_response("getAllUsers", to_array_of_hashes(users))
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
		user = User.create extract_non_model_attributes(params, User)
		render json: api_response("createUser", user.to_hash)
	end

end