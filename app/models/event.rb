class Event < ActiveRecord::Base
	has_many :polls, dependent: :destroy
	belongs_to :user
	has_many :users, through: :outings
	has_many :outings
	belongs_to :service

	attr_accessible :finished, :user_id, :service_id, :comment, :start_time, :name, :status, :complete, :confirmation_id, :threshold, :current_choice

	def activate_polls 
		update_attributes status: 'activated'
		created_users = []
		polls.each do |poll|
			poll.generate_url
			if poll.email
				user = User.create email: poll.email
				users << user
				created_users << user
				# UserMailer.poll_email(poll).deliver 
			end
		end
		created_users
	end

	def vote_count
		polls.where(answered: true).count
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
	


end




