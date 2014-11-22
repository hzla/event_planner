class Api::V1::ServicesController < ApplicationController

  include ApplicationHelper
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def index
    services = Service.order(:available).reverse
    render json: api_response("services", to_array_of_hashes(services))
  end
end
