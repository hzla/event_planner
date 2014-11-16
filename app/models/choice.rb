class Choice < ActiveRecord::Base
	belongs_to :poll
	attr_accessible :value, :desc, :add_info, :poll_id, :replayer_name, :image_url, :yes, :service_id

	def yes_count
		event = poll.event
		poll_ids = event.polls.map(&:id)
		Choice.where(value: value, yes: true).where('poll_id in (?)', poll_ids).count
	end

	def no_count
		event = poll.event
		poll_ids = event.polls.map(&:id)
		Choice.where(value: value, yes: false).where('poll_id in (?)', poll_ids).count
	end

	def score
		yes_count - no_count
	end

	def voters
		poll.choices.where(value: value)
	end

	def opentable_name
		value.gsub('&', 'and').downcase.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-")
	end

end
