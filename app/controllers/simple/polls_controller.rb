class Simple::PollsController < ApplicationController

  include SessionsHelper
  skip_before_action :require_login

  def vote
    @poll = Poll.find params[:id]
    @poll.vote_with params[:choice_values]
    render nothing: true
  end

end
