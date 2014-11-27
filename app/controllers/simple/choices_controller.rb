class Simple::ChoicesController < ApplicationController

  include SessionsHelper
  include ParamsHelper

  def index
    @poll = Poll.find(params[:poll_id])
    @tutorial = session[:new_poll_taker] 
    session[:new_poll_taker] = nil
    @event = @poll.event
    @questions = @poll.questions
  end
   
end
