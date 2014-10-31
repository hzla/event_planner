class Poll < ActiveRecord::Base
	has_many :choices
	belongs_to :event

	attr_accessible :answered, :url, :event_id, :name, :desc, :start_time, :email

	def generate_url
		update_attributes url: "/polls/#{id}?code=#{generate_code}"
	end

	def generate_code
		random = (48..122).map {|x| x.chr}
		characters = (random - random[43..48] - random[10..16])
		code = characters.map {|c| characters.sample}
		code.join
	end

	def user
		event.user
	end

	def takers
		event.polls
	end

end




