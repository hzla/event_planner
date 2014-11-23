class ReservationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform options, user_id, event_id, choice_id
    user = User.find user_id
    event = Event.find event_id
    choice = Choice.find choice_id
    Opentable.reserve(options, event, choice, user.email)
  end
end
