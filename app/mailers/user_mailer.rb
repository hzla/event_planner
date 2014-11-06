class UserMailer < ActionMailer::Base
  default from: 'mailer@instagator.com'
 
  def poll_email poll
    @poll = poll
    @host = "http://localhost:3000"
    mail(to: poll.email, subject: "#{poll.event.name}")
  end

  def reservation_info url, email
  	@host = "http://localhost:3000"
  	@url = url
  	mail(to: email, subject: "Your Reservation")
  end

  
end