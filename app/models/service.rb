class Service < ActiveRecord::Base
	has_many :events
	attr_accessible :name, :image, :url

	before_create :generate_url

	def generate_url
		self.url = "/#{name.gsub(' ', '').downcase}"
	end

	def event_url event_id
		url + "?event_id=#{event_id}"
	end





end