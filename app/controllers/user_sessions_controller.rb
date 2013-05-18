class UserSessionsController < Devise::SessionsController
  layout "login"

  def new
    session[:user_registration_return_to] ||= '/admin'
    super
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    if session[:current_page] && (!request.referer.include?('/admin') && !request.referer.include?('/admin/signup'))
      request.referer + "&p=#{session[:current_page]}&u=#{session[:current_widget_host]}&k=#{session[:current_widget_key]}"
    else
      request.referer
    end

  end

end