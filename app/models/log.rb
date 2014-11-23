class Log < ActiveRecord::Base
  attr_accessible :message, :event_id
  belongs_to :event

  def self.update_number_success event
  end

  def self.update_number_failure event
  end

  def self.ended_poll event
  end

  def self.update_location_failure event
  end

  def self.update_location_success event
  end

  def self.book_location_failure event
  end

  def self.book_location_success event
  end

  def html_message
    message.html_safe
  end

end
