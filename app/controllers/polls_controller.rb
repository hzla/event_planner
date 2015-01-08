class PollsController < ApplicationController

  include SessionsHelper
  skip_before_action :require_login, only: "show"

  def find_or_create #redirected from sessions#create after clicking on sign up on event#route page
    @event = Event.find params[:event_id]
    session[:route_poll] = nil
    if @event.user_id == current_user.id || @event.polls.pluck(:user_id).include?(current_user.id) #if the current user created the event
      poll = @event.polls.where(user_id: current_user.id).first
      redirect_to poll.url and return
    else #if the user doesn't have a poll for this event yet
      poll = Poll.create event_id: @event.id, email: current_user.email, user_id: current_user.id
      @event.populate_polls_with_choices
      @event.users << current_user
      redirect_to poll.url
    end
  end

  def rsvp
    Poll.find(params[:id]).update_attributes confirmed_attending: true
    render nothing: true
  end

  private

  def check_event_ownership
    if params[:event_id]
      event = Event.find params[:event_id]
      if event.user_id != session[:user_id]
        redirect_to dashboard_path
      else
        @event_id = params[:event_id]
      end
    end
  end

end
