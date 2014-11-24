class UsersController < ApplicationController

  include SessionsHelper

  def dashboard
    @event = Event.new
    @events = current_user.events.where(status: "activated").uniq
    @tutorial = @events.empty?

    if params[:code] #quick user switching for bug testing purposes
      session[:user_id] = params[:monkey].to_i
    end
    if params[:tutorial] #for bug testing tutorial
      @tutorial = params[:tutorial] == "true"
    end
  end

  def activate
    emails = ["andylee.hzl@gmail.com", "hsia.kenneth@gmail.com", 'bob@instagator.com']
    activated = false
    if emails.include? params[:activation_email]
      current_user.update_attributes activation: params[:activation_email]
      activated = true
    end
    render json: {activated: activated}
  end
end
