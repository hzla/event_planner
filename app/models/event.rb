class Event < ActiveRecord::Base
	has_many :polls, dependent: :destroy
	belongs_to :user
	has_many :users, through: :outings
	has_many :outings
	has_many :logs
	belongs_to :service

	attr_accessible :processing_choice, :finished, :user_id, :service_id, :comment, :start_time, :end_time, :start_date, :name, :status, :complete, :confirmation_id, :threshold, :current_choice, :expiration, :recurring

	def activate_polls 
		update_attributes status: 'activated'
		created_users = []
		polls.each do |poll|
			poll.generate_url
			if poll.email 
				user = nil
				if poll.user_id
					user = User.find poll.user_id
				else
					user = User.create email: poll.email, activation: poll.code
					created_users << user
				end
				users << user
				# UserMailer.poll_email(poll).deliver 
			end
		end
		created_users
	end

	def update_times
		new_start = start_time
		new_start = new_start.change day: start_date.day, month: start_date.month
		new_end = end_time
		new_end = new_end.change day: start_date.day, month: start_date.month
		self.update_attributes start_time: new_start, end_time: new_end
	end

	def parsed_start_time
		start_time.strftime("%m/%d/%Y %H:%M:00")
	end

	def parsed_end_time
		end_time.strftime("%m/%d/%Y %H:%M:00")
	end


	def vote_count
		polls.where(confirmed_attending: true).count
	end

	def voted
		vote_count = polls.count
	end

	def top_choices
		polls.first.choices.sort_by do |choice|
			choice.yes_count
		end.reverse
	end

	def create_threshold
		count = (polls.count / 2) + 1
		update_attributes threshold: count
	end

	def attending_count
		polls.where(confirmed_attending: true).count
	end

	def voted_on_by? user
		!polls.where(user_id: user.id, confirmed_attending: true).empty?
	end

	def owned_by? user
		user_id == user.id
	end

	def last_log
		logs.order('created_at desc').first if logs
	end

	def vote_url user
		polls.where(user_id: user.id).first.url
	end

	def html_classes user
		classes = " "
		classes += "reserved " if current_choice != nil && !ongoing?
		classes += "top " if !owned_by?(user) && !voted_on_by?(user)
		classes += "ongoing " if ongoing?
		classes
	end

	def ongoing?
		expiration > Time.now
	end

	def time_info
		date = start_date.strftime("%b %d, %Y at ")
		time = start_time.strftime("%l:%M %p")
		date + time
	end

	def time_left
		p self
		puts "\n" * 10
		((expiration - Time.now) / 3600).round
	end

end




