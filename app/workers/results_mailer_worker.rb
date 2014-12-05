class ResultsMailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform user_id, event_id
    user = User.find user_id
    event = Event.find event_id
    UserMailer.results(user, event).deliver
  end
end
