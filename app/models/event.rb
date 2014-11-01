class Event < ActiveRecord::Base
	has_many :polls, dependent: :destroy
	belongs_to :user
	belongs_to :service

	attr_accessible :finished, :user_id, :service_id, :desc, :start_time, :name, :status, :complete

	def activate_polls
		update_attributes status: 'activated'
		polls.each do |poll|
			poll.generate_url
			#UserMailer.poll_email(poll).deliver
		end
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


end




