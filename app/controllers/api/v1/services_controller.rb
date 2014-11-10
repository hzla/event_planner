class Api::V1::ServicesController < ApplicationController

	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login

	def index
		services = Service.order(:available).reverse
		render json: services.to_json
	end

end
