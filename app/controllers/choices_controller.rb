class ChoicesController < ApplicationController

  include SessionsHelper
  include ParamsHelper
  before_filter :check_event_ownership

  def index
    @poll = Poll.find(params[:poll_id])
    @tutorial = session[:new_poll_taker] 
    session[:new_poll_taker] = nil
    @event = @poll.event
    if @event.locked
      redirect_to simple_results_path(@event) and return
    end
    if params[:code] != @poll.url.split("?code=").last
      redirect_to root_path
    end
    @choices = @poll.choices
    if @choices.first.choice_type != nil
      redirect_to simple_poll_choices_path(poll_id: @poll.id) and return
    end

    if !@browser.mobile? 
      @images = ["desktut1.png", "desktut2.png", "desktut3.png"]
    else
      @images = ["mvotertut1.png", "mvotertut2.png", "mvotertut3.png"]
    end
    render 'index'
  end

  def rsvp
    poll = Poll.find(params[:id])
    poll.update_attributes confirmed_attending: true
    render nothing: true
  end

  def create
    choice_info = extract_choice_attribute_arrays_from params
    @event.choices.destroy_all if !@event.choices.empty?
    Choice.create_choices_using_list_of_attributes choice_info, @event
    @event.populate_polls_with_choices
    redirect_to event_path(@event_id)
  end

  def vote
    choice = Choice.find params[:id]
    poll = choice.poll
    answer = params[:answer]
    delta = choice.next_vote_delta
    changed = choice.answer_and_return_change_status answer
    render json: {changed: changed, answer: answer, delta: delta}
  end

  def decide_vote
    @poll = Poll.find(params[:id])
    @event = @poll.event
    @choice = @poll.top_choice
    user = @poll.event.user
    UserMailer.vote_email(@poll, user).deliver if user.mail_on_vote
    if @event.should_book?(@choice) 
      ReservationWorker.perform_async({restaurant_id: @choice.service_id, start_time: @event.parsed_start_time,
      end_time: @event.parsed_end_time, party_size: @event.rsvps , first_name: @event.user.first_name, last_name: @event.user.last_name, 
      email: @event.user.email, phone_number: "9499813668"}, @event.user.id, @event.id, @choice.id)
    # elsif (@event.rsvps >= @event.threshold && @event.confirmation_id != nil && @event.current_choice == @top_choice.value)
    #   #modify reservation
    # else
    end 
    render nothing: true
  end
  
  private

  def check_event_ownership
    if params[:event_id]
      @event = Event.find params[:event_id]
      if @event.user_id != session[:user_id]
        redirect_to dashboard_path
      else
        @event_id = params[:event_id]
      end
    end
  end
end
