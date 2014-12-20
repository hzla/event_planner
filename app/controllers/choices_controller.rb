class ChoicesController < ApplicationController

  include SessionsHelper
  include ParamsHelper
  before_filter :check_event_ownership

  def index
    @poll = Poll.find(params[:poll_id])
    @tutorial = session[:new_poll_taker] 
    session[:new_poll_taker] = nil
    @event = @poll.event
    @choices = @poll.choices
    
    if @event.locked #if voting on this poll has been closed
      redirect_to simple_results_path(@event) and return
    end
    if params[:code] != @poll.url.split("?code=").last #if the url is incorrect
      redirect_to root_path and return
    end
    if @choices.first.choice_type != nil && @choices.first #if this is a simple/anything goes poll
      redirect_to simple_poll_choices_path(poll_id: @poll.id) and return
    end

    if @browser.mobile?  #tutorial images
      @images = ["mvotertut1.png", "mvotertut2.png", "mvotertut3.png"]
    else
      @images = ["desktut1.png", "desktut2.png", "desktut3.png"]
    end

    render 'index'
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
      end_time: @event.parsed_end_time, party_size: @event.rsvps , first_name: user.first_name, last_name: user.last_name, 
      email: user.email, phone_number: "9499813668"}, @event.user.id, @event.id, @choice.id)
     elsif @event.should_modify?(@choice)
        @event.update_attributes processing_choice: @choice.value
        restaurant_id = @choice.service_id
        start_time = URI.encode(@event.parsed_start_time).gsub('/','%2F').gsub(':','%3A')
        base_url = "https://m.opentable.com/reservation/details?"
        url_params = "RestaurantID=#{restaurant_id}&Points=100&SecurityID=0&DateTime=#{start_time}&PartySize=#{@event.rsvps}&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=False&ArePopPoints=False"
        url = base_url + url_params
        time_range = "#{@event.parsed_start_time} to #{@event.parsed_end_time}"
        old_rest_id = Restaurant.find_by_name(@event.current_choice).opentable_id 
        cancel_url = "https://m.opentable.com/reservation/view?RestaurantID=#{old_rest_id}&ConfirmationNumber=#{@event.confirmation_id}"
        UserMailer.reservation_failure(@event, url, time_range, cancel_url).deliver
     else
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
