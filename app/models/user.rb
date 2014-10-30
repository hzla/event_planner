class User < ActiveRecord::Base
	has_many :authorizations, dependent: :destroy
	has_many :events

	attr_accessible :name, :email, :profile_pic_url, :location

	def self.create_with_facebook auth_hash
		timezone = auth_hash.extra.raw_info.timezone
		profile = auth_hash['info']
		fb_token = auth_hash.credentials.token
		user = User.new name: profile['name'], email: profile['email'], profile_pic_url: profile['image'], location: profile['location']
    user.authorizations.build :uid => auth_hash["uid"]
    user if user.save
	end
end




