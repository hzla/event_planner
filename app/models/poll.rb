class Poll < ActiveRecord::Base
  has_many :choices, dependent: :destroy
  belongs_to :event
  belongs_to :user

  attr_accessible :routing_url, :confirmed_attending, :answered, :url, :user_id, :event_id, :name, :desc, :start_time, :email, :phone_number
  after_create :generate_url

  def generate_url
    update_attributes url: "/polls/#{id}/choices?code=#{generate_code}"
  end

  def generate_code
    random = (48..122).map {|x| x.chr}
    characters = (random - random[43..48] - random[10..16])
    code = characters.map {|c| characters.sample}
    code.join
  end

  def questions #a hash with questions as keys and corresponding array of choices as values
    choices.order(:value).group_by {|c| c.question }
  end

  def all_selected_values #for use in results and voting
    choices.where(yes: true).pluck(:value).join("<separator>")
  end

  def vote_with choice_values
    values = choice_values.split("<separator>")
    choices.update_all yes: nil
    values.each do |value|
      choice = choices.where(value: value).first
      choice.update_attributes yes: true if choice
    end
  end

  def values_for question
    choices.where(question: question).map(&:value).join("<separator>")
  end

  def selected_values_for question
    choices.where(question: question, yes: true).map(&:value).join("<separator>")
  end

  def choices_for question
    choices.where(question: question).order(:value)
  end
  def top_choice
    choices.sort_by(&:score).reverse.first
  end

  def code
    url.split("code=")[-1]
  end

  def takers
    Poll.where event_id: event_id
  end

  def voted? question
    !choices.where(question: question, yes: true).empty?
  end

  def voted_on?
    choices.where(yes: nil).count < choices.count
  end

  def get_choices
    event.populate_polls_with_choices
  end

  def avatar 
    user = User.where(email: email)
    if user.empty?
      n = (1..12).to_a.sample
      "p#{n}.png"
    else
      user.first.profile_pic_url
    end
  end

  def self.update_urls
    all.each(&:generate_url)
  end
end
