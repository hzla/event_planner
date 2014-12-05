class UserMailer < ActionMailer::Base
  default from: 'mailer@instagator.com'

  def poll_email poll
    @poll = poll
    @host = "http://www.dinnerpoll.com"
    mail(to: poll.email, subject: "#{poll.event.name}")
  end

  def vote_email poll, user
    @poll = poll
    @host = "http://www.dinnerpoll.com"
    mail(to: user.email, subject: "#{poll.user.name} voted on #{poll.event.name}")
  end

  def reservation_info url, email
    @host = "http://www.dinnerpoll.com"
    @url = url
    mail(to: email, subject: "Your Reservation")
  end

  def reservation_success event, email 
    @host = "http://www.dinnerpoll.com"
    @event = event
    mail(to: email, subject: "Your Reservation at #{event.current_choice} for #{event.threshold} people has been booked!")
  end

  def reservation_failure event, url, time_range
    @host = "http://www.dinnerpoll.com"
    @event = event
    @user = event.user
    @time_range = URI.decode(time_range).gsub('%2F','%/').gsub('%3A',':')
    @url = url
    mail(to: 'andylee.hzl@gmail.com', subject: "#{@user.name}'s reservation for #{@event.processing_choice} has failed.")
  end

  def results user, event
    @host = "http://www.dinnerpoll.com"
    @event = event
    @user = user
    mail(to: user.email, subject: "Results for #{event.name}'s poll.")
  end
end
