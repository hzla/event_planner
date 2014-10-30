class Poll < ActiveRecord::Base
	has_many :choices
	belongs_to :event

	attr_accessible :answered, :url, :event_id, :name, :desc, :start_time, :email

end




