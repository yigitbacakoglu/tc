class UserSessionsController < Devise::SessionsController
  layout "login"

  def new
    session[:user_registration_return_to] ||= '/admin'
    super
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    if cookies[:current_page] && (!request.referer.include?('/admin') && !request.referer.include?('/admin/signup'))
      request.referer + "&p=#{cookies[:current_page]}&u=#{cookies[:current_widget_host]}&k=#{cookies[:current_widget_key]}"
    else
      request.referer
    end

  end

end