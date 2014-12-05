class Simple::ChoicesController < ApplicationController

  include SessionsHelper
  include ParamsHelper

  def index

    @poll = Poll.find(params[:poll_id])
    @event = @poll.event
    if @event.locked
    	redirect_to simple_results_path(@event)
    end
    @tutorial = session[:new_poll_taker] 
    session[:new_poll_taker] = nil
    
    @questions = @poll.questions
  end
   
end
