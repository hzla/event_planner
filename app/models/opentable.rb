class Opentable 

	def initialize
	end

	def self.search location
		query = nil
		location = location.gsub(' ', '%20')
		if location.to_i > 0
			query = "zip=#{location}&per_page=100"
		else
			query = "city=#{location}&per_page=100"
		end
		url = "http://opentable.herokuapp.com/api/restaurants?#{query}"
		places = HTTParty.get(url)["restaurants"]
		places
	end



	def self.options location=nil
		location = "San Francisco" if !location
		location = location.gsub(' ', '%20')
		url = "http://opentable.herokuapp.com/api/restaurants?city=#{location}&per_page=100"
		places = HTTParty.get(url)["restaurants"]
		places
	end

	def self.image_for restaurant
		"http://www.opentable.com/img/restimages/#{restaurant["id"]}.jpg"
	end

	def self.reserve options=nil, event=nil, choice=nil, email=nil
		base_url = 'http://hidden-bastion-8862.herokuapp.com/api/v1/opentable/reserve?'
		event = Event.last if !event
		choice = Choice.last if !choice
		email = "andylee.hzl@gmail.com" if !email
		options = {'restaurant_id' => choice.service_id, 'start_time' => "11/20/2014 18:30:00", 'end_time' => '11/20/2014 20:30:00', 'party_size' => 2, 'first_name' => "Robert", 'last_name' => "Gustavez", 'email' => "neohzla@gmail.com", 'phone_number' => "4157760400"} if !options
		options['start_time'] = URI.encode(options['start_time']).gsub('/','%2F').gsub(':','%3A')
		options['end_time'] = URI.encode(options['end_time']).gsub('/','%2F').gsub(':','%3A')
		options_url = ''
		options.each do |k, v|
			options_url += "#{k.to_s}=#{v.to_s}&"
		end
		url = base_url + options_url
		response = HTTParty.get(url).parsed_response
		parsed_response = JSON.parse(response["success"])
		puts parsed_response
		puts "\n" * 20
		if parsed_response["id"]
			c_id = parsed_response["confirmation_id"]
			cancel(event.confirmation_id) if event.confirmation_id
			event.update_attributes confirmation_id: c_id.to_i, current_choice: choice.value
		else
			url =  parsed_response["url"]
			event.update_attributes processing_choice: choice.value
			UserMailer.reservation_info(url, email).deliver
		end
		parsed_response
	end

	def self.modify c_id, time
		url = "http://hidden-bastion-8862.herokuapp.com/api/v1/opentable/modify?c_id=#{c_id}&time=#{time}"
		HTTParty.get(url).parsed_response
	end

	def self.cancel c_id
		url = "http://hidden-bastion-8862.herokuapp.com/api/v1/opentable/cancel?c_id=#{c_id}"
		HTTParty.get(url).parsed_response
	end


end
