class ChoicesController < ApplicationController

	include SessionsHelper
	include ParamsHelper
	before_filter :check_event_ownership

	def create
		choice_info = extract_choice_attribute_arrays_from params
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
		if @event.should_book?(@choice) 
			ReservationWorker.perform_async({restaurant_id: @choice.service_id, start_time: @event.parsed_start_time,
			end_time: @event.parsed_end_time, party_size: @event.rsvps , first_name: @event.user.first_name, last_name: @event.user.last_name, 
			email: @event.user.email, phone_number: "9499813668"}, @event.user.id, @event.id, @choice.id)
		# elsif (@event.rsvps >= @event.threshold && @event.confirmation_id != nil && @event.current_choice == @top_choice.value)
		# 	#modify reservation
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
