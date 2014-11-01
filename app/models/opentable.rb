class Opentable 

	def initialize
	end

	def self.options location=nil
		location = "San Francisco" if !location
		location = location.gsub(' ', '%20')
		url = "http://opentable.herokuapp.com/api/restaurants?city=#{location}"
		places = HTTParty.get(url)["restaurants"]
		places
	end

	def self.image_for restaurant
		"http://www.opentable.com/img/restimages/#{restaurant["id"]}.jpg"
	end
end
