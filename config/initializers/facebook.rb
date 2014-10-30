Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'],
           :scope => 'public_profile, email, user_friends', 
           :image_size => 'large'
end