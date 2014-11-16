class Poll < ActiveRecord::Base
	has_many :choices, dependent: :destroy
	belongs_to :event

	attr_accessible :confirmed_attending, :answered, :url, :user_id, :event_id, :name, :desc, :start_time, :email, :phone_number

	def generate_url
		update_attributes url: "/polls/#{id}?code=#{generate_code}"
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

	def user
		event.user
	end

	def takers
		event.polls
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

end




