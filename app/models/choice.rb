class Choice < ActiveRecord::Base
	belongs_to :poll
	attr_accessible :value, :desc, :add_info, :poll_id, :replayer_name

end
