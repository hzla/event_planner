class EventsController < ApplicationController

  include SessionsHelper

  before_filter :get_event, only: [:activate, :route, :generate_poll, :show, :lock]
  skip_before_filter :require_login, only: [:route]

  
  def create
    @event = Event.create params[:event]
    #create a poll for the person who created the event
    @event.assign_user_and_create_first_poll current_user 
    redirect_to opentable_path(event_id: @event.id)
  end

  def lock
    @event.update_attributes locked: true  
    @event.users.each do |user| #email all users when ending a poll
      ResultsMailerWorker.perform_async(user.id, @event.id)
    end
    redirect_to dashboard_path
  end

  def route # from event#routing_url
    session[:user_id] = nil
    session[:route_poll] = true
    session[:event_id] = params[:id]
    #session data for after the facebook callback
  end

  def show 
    @poll = @event.polls.where(user_id: current_user.id).first
    @service = Service.find @event.service_id
    @choices = @event.choices
    @event.update_attributes status: "activated"
  end

  private

  def get_event
    @event = Event.find(params[:id])
  end
end
