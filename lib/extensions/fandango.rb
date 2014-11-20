class Fandango

	def self.movies location=nil
		time = Time.now.strftime("%H:%M")
		url = "http://hidden-bastion-8862.herokuapp.com/api/v1/fandango/movies?lat=34&lng=-118&start_time=#{time}"
		places = HTTParty.get(url)["movies"]
	end
	
end
