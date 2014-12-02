class Simple::EventsController < ApplicationController

  include SessionsHelper

  before_filter :get_event, only: [:activate, :route, :generate_poll, :show]

  def new
    @event = Event.new
  end

  def create
    if params["questions"] != ","
      event = Event.create_simple_event params, current_user
    end
    render json: {created_event: event.to_json, poll: event.polls.first.to_json} and return
  end

  def index
  end

  def results
    @event = Event.find params[:id]
    @questions = @event.polls.first.questions
  end

  private

  def get_event
    @event = Event.find(params[:id])
  end
end
