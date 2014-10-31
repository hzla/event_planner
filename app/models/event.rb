class Event < ActiveRecord::Base
	has_many :polls, dependent: :destroy
	belongs_to :user
	belongs_to :service

	attr_accessible :finished, :user_id, :service_id, :desc, :start_time, :name, :status

	def activate_polls
		update_attributes status: 'activated'
		polls.each do |poll|
			poll.generate_url
			UserMailer.poll_email(poll).deliver
		end
	end


end




