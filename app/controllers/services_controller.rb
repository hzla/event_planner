class ServicesController < ApplicationController

  include SessionsHelper
  before_filter :check_event_ownership

  def index
    @services = Service.order(:available).reverse
  end

  def opentable
    if @event_id
      opentable_id = Service.where(name: "Open Table").first.id
      Event.find(@event_id).update_attributes(service_id: opentable_id)
    end
    location = current_user.location ? current_user.location.split(',')[0] : nil
    @options = Opentable.local_options(location).sort_by(&:rating).reverse
  end

  def opentable_search
    @location = params[:location]
    @options = Opentable.search(params[:location]).sort_by(&:rating).reverse
    render layout: false
  end

  private

  def check_event_ownership
    if params[:event_id]
      event = Event.find params[:event_id]
      if event.user_id != session[:user_id]
        redirect_to dashboard_path
      else
        @event_id = params[:event_id]
      end
    end
  end
end
