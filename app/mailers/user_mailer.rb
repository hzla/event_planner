class UserMailer < ActionMailer::Base
  default from: 'mailer@instagator.com'
 
  def poll_email poll
    @poll = poll
    @host = "http://instagator2014.herokuapp.com"
    mail(to: poll.email, subject: "#{poll.event.name}")
  end

  def reservation_info url, email
  	@host = "http://instagator2014.herokuapp.com"
  	@url = url
  	mail(to: email, subject: "Your Reservation")
  end

  
end