class ApplicationController < ActionController::Base
  protect_from_forgery

  layout "application"
  prepend_before_filter :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def set_current_user
    User.current = user_registration_signed_in? ? current_user_registration.user : nil
    @current_user = User.current
  end
end
