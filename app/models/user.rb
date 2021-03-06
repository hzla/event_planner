class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy
  has_many :events, through: :outings
  has_many :outings, dependent: :destroy
  attr_accessible(:name, :email, :profile_pic_url, :location, :phone_number,
  :uu_id, :activation, :mail_on_vote, :mail_on_res_success, :mail_on_res_failure, :mail_on_res_24_hour)


  def self.create_with_facebook auth_hash
    timezone = auth_hash.extra.raw_info.timezone
    profile = auth_hash['info']
    fb_token = auth_hash.credentials.token
    user = User.new name: profile['name'], email: profile['email'], profile_pic_url: profile['image'], location: profile['location'], activation: 'activated'
    user.authorizations.build :uu_id => auth_hash["uid"]
    user if user.save
  end

  def first_name
    name.split(" ")[0]
  end

  def short_name
    names = name.split(" ")[0..1]
    names[1] = names[1][0] + "."
    names.join(" ")
  end

  def created_events
    Event.where(user_id: id)
  end

  def dinner_poll_events
    events.where('threshold is not null')
  end

  def anything_goes_events
    events.where(threshold: nil)
  end

  def dashboard_events
    events = dinner_poll_events.where(status: "activated", locked: nil).where('start_date > (?)', Time.now).order(:start_date) + anything_goes_events.where(status: "activated", locked: nil).order('created_at desc')
    
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
