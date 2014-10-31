class Event < ActiveRecord::Base
	has_many :polls, dependent: :destroy
	belongs_to :user
	belongs_to :service

	attr_accessible :finished, :user_id, :service_id, :desc, :start_time, :name, :status


end




