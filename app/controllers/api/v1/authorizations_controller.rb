class Api::V1::AuthorizationsController < ApplicationController
	
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login

	def index
		authorizations = Authorization.all
		new_params = extract_non_model_attributes(params, Authorization, true)
		if new_params
			authorizations = authorizations.where(new_params)
		end
		render json: api_response("authorizations", to_array_of_hashes(authorizations))
	end

	def create 
		if !params["record_id"]
			authorization = Authorization.create extract_non_model_attributes(params, Authorization)
			render json: api_response("createAuthorization", to_hash(authorization)) and return
		else
			authorization = Authorization.find params["record_id"]
			authorization.update_attributes extract_non_model_attributes(params, authorization)
			render json: api_response("updateAuthorization", to_hash(authorization)) and return
		end
	end

end