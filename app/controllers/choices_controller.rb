class ChoicesController < ApplicationController
	
	include SessionsHelper
	before_filter :check_event_ownership

	def create
		images = params[:image_url_list].split("<OPTION>")
		titles = params[:title_list].split("<OPTION>")
		infos = params[:info_list].split("<OPTION>")
		polls = Event.find(@event_id).polls

		polls.each do |poll|
			(0..(images.length - 1)).each do |i|
				Choice.create poll_id: poll.id, image_url: images[i], value: titles[i], add_info: infos[i]
			end
		end
		redirect_to event_path(@event_id)	
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
