class Event < ActiveRecord::Base
	has_many :polls, dependent: :destroy
	belongs_to :user
	has_many :users, through: :outings
	has_many :outings, dependent: :destroy
	has_many :logs, dependent: :destroy
	has_many :choices, dependent: :destroy
	belongs_to :service

	after_create :generate_routing_url
	after_create :update_times

	attr_accessible(:locked, :routing_url, :processing_choice, 
	:user_id, :service_id, :comment, :start_time, :end_time, :start_date, 
	:name, :status, :confirmation_id, :threshold, :current_choice, 
	:expiration, :recurring)

	

	def self.create_simple_event params, user
		event = Event.create name: params["event_name"], status: "activated"
		position = 1
		questions = params["questions"].split("<separator>")
		questions.each do |q|
			sub_position = 1
			params["date_choice_list_#{position}"].split(",").uniq.each do |choice|
				Choice.create question: q, value: choice, event_id: event.id, choice_type: "date", position: position, sub_position: sub_position
				sub_position += 1
			end
			params["text_choice_list_#{position}"].split("<separator>").each do |choice|
				Choice.create question: q, value: choice, event_id: event.id, choice_type: "text", position: position, sub_position: sub_position
				sub_position += 1
			end
			position += 1
		end
		event.assign_user_and_create_first_poll user
		event.populate_polls_with_choices
		event
	end

	def populate_polls_with_choices #duplicates event's choices into the event's polls. 
		polls.each do |poll|
			if poll.choices.empty?
				choices.each do |choice|
					Choice.create poll_id: poll.id, value: choice.value, 
					choice_type: choice.choice_type, add_info: choice.add_info,
					image_url: choice.image_url, question: choice.question, service_id: choice.service_id, position: position, sub_position: sub_position
				end
			end
		end
	end

	def processing_opentable_url #used in the url to obtain opentable page
    name = processing_choice.gsub(/(\w)-(\w)/, '\1 \2').gsub(/(\w)-(\w)/, '\1 \2').gsub('&', 'and').gsub(" - ", " ").downcase.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-")
    "http://www.opentable.com/#{name}"
  end

	def assign_user_and_create_first_poll user
		users << user
		update_attributes user_id: user.id
		Poll.create email: user.email, event_id: id, user_id: user.id, confirmed_attending: true
	end

	def rsvps
		polls.where(confirmed_attending: true).count
	end

	def response_count 
		polls.select {|poll| poll.voted_on? }.length
	end

	def top_choices
		polls.first.choices.sort_by do |choice|
			choice.yes_count
		end.reverse
	end

	def should_book? choice #if first quorum has been reached or if quorum has been reached on a new choice
		(rsvps >= threshold && current_choice == nil) #|| (rsvps >= threshold && current_choice != nil && current_choice != choice.value)
	end

	def should_modify? choice
		(rsvps >= threshold && confirmation_id != nil && current_choice != choice.value)
	end

	def attending_count
		polls.where(confirmed_attending: true).count
	end

	def html_classes user
		classes = " "
		classes += "reserved " if current_choice != nil && !ongoing?
		classes += "top " if !owned_by?(user) && !voted_on_by?(user)
		classes += "ongoing " if ongoing?
		classes
	end

	def voted_on_by? user
		!polls.where(user_id: user.id, confirmed_attending: true).empty?
	end

	def owned_by? user
		user_id == user.id
	end

	def ongoing?
		if end_time
			(end_time - 24.hours) > Time.now
		end
	end

	def last_log
		logs.order('created_at desc').first if logs
	end

	def vote_url user
		polls.where(user_id: user.id).first.url
	end

	def code
		routing_url.split("?code=").last
	end

	def time_info
		if start_date
			date = start_date.strftime("%b %d, %Y at ")
			time = start_time.strftime("%l:%M %p - ") + end_time.strftime("%l:%M %p")
			date + time
		end
	end

	def time_left
		(((end_time - 24.hours) - Time.now) / 3600).round
	end

	def time_range_values
		[start_time.hour * 60 + start_time.min , end_time.hour * 60 + start_time.min]
	end

	def parsed_start_time #for opentable bot
		start_time.strftime("%m/%d/%Y %H:%M:00")
	end

	def parsed_end_time #for opentable bot
		end_time.strftime("%m/%d/%Y %H:%M:00")
	end

	def service_pic 
		if choices.first && choices.first.choice_type != nil && !choices.empty?
			'event-custom-icon.svg'
		else
			'event-opentable-icon.svg'
		end
	end

	def poll_type #what kind of event it is ie. opentable, custom
		choices.first.choice_type
	end

	def questions
		choices.order(:position).pluck(:question).uniq
	end

	private

	def generate_routing_url
		update_attributes routing_url: "/events/#{id}/take?code=#{generate_code}"
	end

	def generate_code
		random = (48..122).map {|x| x.chr}
		characters = (random - random[43..48] - random[10..16])
		code = characters.map {|c| characters.sample}
		code.join[0..15]
	end

	def update_times #should refactor later, used to change the dates in start time and end_time to the date in start_date
		if start_time
			new_start = start_time
			new_start = new_start.change day: start_date.day, month: start_date.month, year: start_date.year
			new_end = end_time
			new_end = new_end.change day: start_date.day, month: start_date.month, year: start_date.year
			self.update_attributes start_time: new_start, end_time: new_end
		end
	end
end
