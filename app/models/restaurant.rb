class Restaurant < ActiveRecord::Base
	attr_accessible :popularity, :name, :address, :city, :state, :review_count, :rating, :opentable_id, :lat, :long, :pricing_info
end


# 31852278  a.parsed_response[31852278..-18613]