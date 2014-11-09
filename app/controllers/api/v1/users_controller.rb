class Api::V1::UsersController < ApplicationController
	
	include SessionsHelper
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login

	def index
		users = User.all.to_json
		if params[:user]
			users = User.where(params[:user]).to_json
		end
		users = User.all.to_json
	end

	def show
		user = User.find params[:id]
		render json: user.to_json
	end

	def update
		user = User.find params[:id]
		user.update_attributes params[:user]
		render json: user.to_json
	end

	def create
		user = User.create params[:user]
		render json: user.to_json
	end

end