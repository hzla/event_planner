class Choice < ActiveRecord::Base
  belongs_to :poll
  belongs_to :event
  attr_accessible :choice_type, :question, :event_id, :value, :desc, :add_info, :poll_id, :replayer_name, :image_url, :yes, :service_id

  def self.create_choices_using_list_of_attributes choice_info, event
    p choice_info
    (0..(choice_info[:length] - 1)).each do |i|
      p choice_info[:service_ids][i]
      create(event_id: event.id, image_url: choice_info[:images][i],
      value: choice_info[:titles][i], add_info: choice_info[:infos][i],
      service_id: choice_info[:service_ids][i])
    end
  end

  def yes_count
    event = poll.event
    poll_ids = event.polls.map(&:id)
    Choice.where(value: value, yes: true).where('poll_id in (?)', poll_ids).count
  end

  def no_count
    event = poll.event
    poll_ids = event.polls.map(&:id)
    Choice.where(value: value, yes: false).where('poll_id in (?)', poll_ids).count
  end

  def score
    yes_count - no_count
  end

  def opentable_name
    value.gsub('&', 'and').downcase.gsub(/[^0-9a-z ]/i, '').gsub(" ", "-")
  end

  def is_current
    event.current_choice == value
  end

  def is_processing
    event.processing_choice == value
  end

  def self.update_event_ids
    all.each do |choice|
      choice.update_attributes event_id: choice.poll.event_id
    end
  end

  def next_vote_delta
    delta = yes == nil ? 1 : 2
    delta
  end

  def answer_and_return_change_status answer
    response = (answer == "yes")
    change_status = (yes != response ) || yes == nil
    update_attributes yes: response
    change_status
  end

  def restaurant
    Restaurant.find_by_opentable_id service_id
  end

  def result_value
    if choice_type == "date"
      Date.parse(value).strftime("%b %d")
    else
      value[0..5]
    end
  end

end
