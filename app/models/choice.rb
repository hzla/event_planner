class Choice < ActiveRecord::Base
	belongs_to :poll
	attr_accessible :value, :desc, :add_info, :poll_id, :replayer_name, :image_url, :yes

	def yes_count
		poll.choices.where(value: value, yes: true).count
	end

	def no_count
		poll.choices.where(value: value, yes: false).count
	end

	def voters
		poll.choices.where(value: value)
	end

end
