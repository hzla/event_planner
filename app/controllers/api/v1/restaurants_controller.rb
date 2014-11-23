class Api::V1::RestaurantsController < ApplicationController

  include SessionsHelper
  include ApplicationHelper
  skip_before_filter  :verify_authenticity_token
  skip_before_filter :require_login

  def index
    # Log.create
    restaurants = Restaurant.all
    location = params[:location]
    new_params = extract_non_model_attributes(params, Restaurant, true)
    if new_params
      restaurants = Restaurant.where(new_params)
    end
    if location
      restaurants = restaurants.where("lower(address) like (?)", "%#{location.downcase}%")
    end
    render json: api_response("restaurants", to_array_of_hashes(restaurants))
  end
end
