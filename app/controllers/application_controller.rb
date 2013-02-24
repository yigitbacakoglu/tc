class ApplicationController < ActionController::Base
  protect_from_forgery
  include BaseHelper
  layout "application"
  prepend_before_filter :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def set_current_user
    User.current = user_registration_signed_in? ? current_user_registration.user : nil
    @current_user = User.current
    save_ip_address
  end

  def save_ip_address
    if @current_user
      @current_user.ip_addresses.find_or_create_by_value(request.remote_ip)
    else
      a = IpAddress.find_or_create_by_value(request.remote_ip)
      @current_anonymous_user = a.user
    end
  end
end
