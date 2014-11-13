class Authorization < ActiveRecord::Base
	belongs_to :user
	validates :uu_id, :presence => true

	attr_accessible :uu_id
end