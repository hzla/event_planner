class Api::V1::ChoicesController < ApplicationController
	
	include SessionsHelper
	skip_before_action :require_login
	skip_before_filter :verify_authenticity_token

	def create
		choice = Choice.create params[:choice]
		render json: choice.to_json
	end

	def show
		choice = Choice.find params[:id]
		render json: choice.to_json
	end

	def update
		choice = Choice.find params[:id]
		choice.update_attributes params[:choice]
		render json: choice.to_json
	end

	def index
		choices = Choice.all
		if params[:choice]
			choices = Choice.where(params[:choice])
		end
		render json: choices.to_json
	end

	def vote
		@choice = Choice.find params[:id]
		@event = @choice.poll.event
		answer = params[:answer]
		if answer == "yes"
			@choice.update_attributes yes: true
		else
			@choice.update_attributes yes: false
		end
		poll = @choice.poll
		if @choice.poll.choices.where(yes: nil).empty?
			poll.update_attributes answered: true
		end
		if @choice.yes_count >= @event.threshold && @event.confirmation_id == nil || (@choice.yes_count >= @event.threshold && @event.confirmation_id != nil && @event.current_choice != @choice.value) 
			ReservationWorker.perform_async({restaurant_id: @choice.service_id, date_time: '11/20/2014 18:30:00',
			party_size: @event.polls.count , first_name: @event.user.first_name, last_name: @event.user.last_name, 
			email: @event.user.email, phone_number: "9499813668"}, @event.user.id, @event.id, @choice.id)
			render json: {bot_action: true, choice: @choice.as_json} and return
		end
		render json: {bot_action: false, choice: @choice.as_json}
	end
end
