class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy
  has_many :credit_cards
  has_many :events, through: :outings
  has_many :outings
  attr_accessible :name, :email, :profile_pic_url, :location, :phone_number, :uu_id, :activation

  include Payment

  def self.create_with_facebook auth_hash
    timezone = auth_hash.extra.raw_info.timezone
    profile = auth_hash['info']
    fb_token = auth_hash.credentials.token
    user = User.new name: profile['name'], email: profile['email'], profile_pic_url: profile['image'], location: profile['location']
    user.authorizations.build :uu_id => auth_hash["uid"]
    user if user.save
  end

  def first_name
    name.split(" ")[0]
  end

  def created_events
    Event.where(user_id: id)
  end

  def last_name
    name.split(" ")[1]
  end

  def to_hash
    model = as_json
    model.each do |k,v|
      model.delete(k) if v == nil
      if v.class == Fixnum
        model[k] = v.to_s
      end
    end
    model
  end
end
