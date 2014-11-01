class ChoicesController < ApplicationController
	
	include SessionsHelper
	before_filter :check_event_ownership

	def create
		images = params[:image_url_list].split("<OPTION>")
		titles = params[:title_list].split("<OPTION>")
		infos = params[:info_list].split("<OPTION>")
		event = Event.find(@event_id)
		polls = event.polls

		polls.each do |poll|
			poll.choices.destroy_all
			(0..(images.length - 1)).each do |i|
				Choice.create poll_id: poll.id, image_url: images[i], value: titles[i], add_info: infos[i]
			end
		end
		redirect_to event_path(@event_id)	
	end

	def vote
		@choice = Choice.find params[:id]
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
