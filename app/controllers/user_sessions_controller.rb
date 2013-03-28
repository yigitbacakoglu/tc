class UserSessionsController < Devise::SessionsController
  layout "login"

  def new
    session[:user_registration_return_to] ||= '/admin'
    super
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    request.referer
  end

end