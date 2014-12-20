class Opentable

  def initialize
  end

  def self.search location
    Restaurant.where("lower(address) like (?)", "%#{location.downcase}%")
  end

  def self.local_options location=nil
    location = "San Francisco" if !location
    Restaurant.where("lower(address) like (?)", "%#{location.downcase}%")
  end

  def self.image_for restaurant
    "http://www.opentable.com/img/restimages/#{restaurant["opentable_id"]}.jpg"
  end

  def self.url_for restaurant
    name = restaurant.name.gsub(/(\w)-(\w)/, '\1 \2').gsub(/(\w)-(\w)/, '\1 \2').gsub('&', 'and').gsub(" - ", " ").downcase.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-").gsub("--", "-")
    "http://www.opentable.com/#{name}"
  end

  def self.reserve options=nil, event=nil, choice=nil, email=nil
    base_url = 'http://hidden-bastion-8862.herokuapp.com/api/v1/opentable/reserve?'
    # uncomment for development use
    # base_url = 'http://localhost:3001/api/v1/opentable/reserve?' 
    # event = Event.last if !event
    # choice = Choice.last if !choice
    # email = "andylee.hzl@gmail.com" if !email
    # options = {'restaurant_id' => choice.service_id, 'start_time' => "11/20/2014 18:30:00", 'end_time' => '11/20/2014 20:30:00', 'party_size' => 2, 'first_name' => "Robert", 'last_name' => "Gustavez", 'email' => "neohzla@gmail.com", 'phone_number' => "4157760400"} if !options
    options['start_time'] = URI.encode(options['start_time']).gsub('/','%2F').gsub(':','%3A')
    options['end_time'] = URI.encode(options['end_time']).gsub('/','%2F').gsub(':','%3A')
    
    options_url = ''
    options.each do |k, v| #convert the options to url params
      options_url += "#{k.to_s}=#{v.to_s}&"
    end
    url = base_url + options_url
    response = HTTParty.get(url).parsed_response #make a request to opentable bot
    parsed_response = JSON.parse(response["success"])
    if parsed_response["id"] #if it was a success, a confirmation_id for the created Meal will be returned
      c_id = parsed_response["confirmation_id"]
      event.update_attributes confirmation_id: c_id.to_i, current_choice: choice.value, processing_choice: nil
      event.users.each do |user|
        UserMailer.reservation_success(event, user.email).deliver if user.mail_on_res_success
      end
    else #if not, a url for the manually making a reservaation will be returned
      url =  parsed_response["url"]
      event.update_attributes processing_choice: choice.value
      UserMailer.reservation_info(url, email).deliver if user.mail_on_res_failure
      UserMailer.reservation_failure(event, url, "#{options['start_time']} to #{options['end_time']}").deliver
    end
    parsed_response
  end

  def self.modify c_id, time #currently not used
    url = "http://hidden-bastion-8862.herokuapp.com/api/v1/opentable/modify?c_id=#{c_id}&time=#{time}"
    HTTParty.get(url).parsed_response
  end

  def self.cancel c_id #currenty not used
    url = "http://hidden-bastion-8862.herokuapp.com/api/v1/opentable/cancel?c_id=#{c_id}"
    HTTParty.get(url).parsed_response
  end
end
