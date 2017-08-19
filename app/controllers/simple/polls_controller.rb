class Simple::PollsController < ApplicationController

  include SessionsHelper
  skip_before_action :require_login

  def vote
    @poll = Poll.find params[:id]
    @poll.vote_with params[:choice_values]
    user = @poll.event.user
    UserMailer.vote_email(@poll, user).deliver if user.mail_on_vote
    redirect_to dashboard_path
  end

end
