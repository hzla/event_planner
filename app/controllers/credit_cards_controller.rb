class CreditCardsController < ApplicationController
  include SessionsHelper

  def new
    @credit_card = CreditCard.new(user: current_user)
  end

  def create
    credit_card = CreditCard.new(params[:credit_card])
    credit_card.user = current_user

    @credit_card = CreateCreditCard.call(credit_card, original_ip: request.remote_ip, original_device: request.user_agent)

    if @credit_card.errors.any?
      render :new
    else
      redirect_to profile_path
    end
  end

  def destroy
    credit_card = CreditCard.find(params[:id])

    # TODO: ensure credit card isn't associated with pending payments
    if credit_card.user_id == current_user.id
      credit_card.wepay_delete
      credit_card.destroy!
    end

    redirect_to(profile_path) and return
  end
end
