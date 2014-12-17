class UsersController < ApplicationController

  include SessionsHelper

  def dashboard #TODO move to events#index
    @event = Event.new
    @events = current_user.events.where(status: "activated").uniq
    @tutorial = @events.empty?
    @show_poll_picker = params[:show_poll_picker] == "true"
    if params[:tutorial] #for bug testing tutorial
      @tutorial = params[:tutorial] == "true"
    end
  end

  def activate #placeholder activate method, will need to be changed later on
    current_user.update_attributes activation: params[:activation_email]
    activated = true
    render json: {activated: activated}
  end

  def edit
    @user = User.find params[:id]
    #for debugging use
    if params[:user_switch]
      session[:user_id] = params[:user_switch]
      redirect_to dashboard_path and return
    end
    redirect_to dashboard_path if @user != current_user
  end

  def update
    if @user != current_user
      redirect_to dashboard_path and return
    end
    @user = User.find params[:id]
    @user.update_attributes params[:user]
    render nothing: true
  end
end
