class Poll < ActiveRecord::Base
	has_many :choices, dependent: :destroy
	belongs_to :event
	belongs_to :user

	attr_accessible :routing_url, :confirmed_attending, :answered, :url, :user_id, :event_id, :name, :desc, :start_time, :email, :phone_number
	after_create :generate_url

	def generate_url
		update_attributes url: "/polls/#{id}/choices?code=#{generate_code}"
	end

	def generate_code
		random = (48..122).map {|x| x.chr}
		characters = (random - random[43..48] - random[10..16])
		code = characters.map {|c| characters.sample}
		code.join
	end

	def top_choice
		choices.sort_by(&:score).reverse.first
	end

	def code
		url.split("code=")[-1]
	end

	def takers
		Poll.where event_id: event_id
	end

	def avatar
		user = User.where(email: email)
		if user.empty?
			n = (1..12).to_a.sample
			"p#{n}.png"
		else
			user.first.profile_pic_url
		end
	end

	def self.update_urls
		all.each(&:generate_url)
	end

end




