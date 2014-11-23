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
end
