class UsersController < ApplicationController

  include SessionsHelper

  def dashboard
    @event = Event.new
    @events = current_user.events.where(status: "activated").uniq
    @tutorial = @events.empty?

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
