class Api::V1::UsersController < ApplicationController
	
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login

	def index
		users = User.all
		if params[:user]
			users = User.where(params[:user]).to_json
		end
		render json: to_array_of_hashes(users)
	end

	def show
		user = User.find params[:id]
		render json: user.to_hash
	end

	def update
		user = User.find params[:id]
		user.update_attributes params[:user]
		render json: user.to_hash
	end

	def create
		user = User.create params[:user]
		render json: user.to_hash
	end

end