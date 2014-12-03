class ProfilesController < ApplicationController
  include SessionsHelper

  def show
    @user = current_user
  end

  def update
    puts "params: #{params.inspect}"

    if params[:profile][:resend_payment_user_registration_confirmation_email]
      current_user.resend_payment_user_registration_confirmation_email
    end

    if params[:profile][:regenerate_payment_access_token]
      user = current_user
      unless user.has_payment_user_id?
        user.create_payment_user(original_ip: request.remote_ip, original_device: request.user_agent, tos_acceptance_time: Time.now.to_i)
      end
      user.save!
    end
    redirect_to profile_path
  end
end
