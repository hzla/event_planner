class ChoicesController < ApplicationController
	
	include SessionsHelper
	before_filter :check_event_ownership

	def create
		images = params[:image_url_list].split("<OPTION>")
		titles = params[:title_list].split("<OPTION>")
		infos = params[:info_list].split("<OPTION>")
		service_ids = params[:id_list].split("<OPTION>")
		event = Event.find(@event_id)
		polls = event.polls
		polls.each do |poll|
			poll.choices.destroy_all
			(0..(images.length - 1)).each do |i|
				Choice.create poll_id: poll.id, image_url: images[i], value: titles[i], add_info: infos[i], service_id: service_ids[i]
			end
		end
		redirect_to event_path(@event_id)	
	end

	def vote
		@choice = Choice.find params[:id]
		@event = @choice.poll.event
		answer = params[:answer]
		if @choice.yes == nil
			delta = 1 
		else
			delta = 2
		end
		if answer == "yes"
			changed = !@choice.yes || @choice.yes == nil
			@choice.update_attributes yes: true
		else
			changed = @choice.yes || @choice.yes == nil
			@choice.update_attributes yes: false
		end
		poll = @choice.poll
		if @choice.poll.choices.where(yes: nil).empty?
			poll.update_attributes answered: true
		end
		
		render json: {changed: changed, answer: answer, delta: delta}
	end

	def decide_vote
		@poll = Poll.find(params[:id])
		@event = @poll.event
		@choice = @poll.top_choice

		if (@event.vote_count >= @event.threshold && @event.current_choice == nil)|| (@event.vote_count >= @event.threshold && @event.current_choice != nil && @event.current_choice != @choice.value) 
			ReservationWorker.perform_async({restaurant_id: @choice.service_id, start_time: @event.parsed_start_time,
			end_time: @event.parsed_end_time, party_size: @event.vote_count , first_name: @event.user.first_name, last_name: @event.user.last_name, 
			email: @event.user.email, phone_number: "9499813668"}, @event.user.id, @event.id, @choice.id)
		# elsif (@event.vote_count >= @event.threshold && @event.confirmation_id != nil && @event.current_choice == @top_choice.value)
		# 	#modify reservation
		# else
		end	
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
