class UserSessionsController < Devise::SessionsController
  layout "login"
  #before_filter :set_devise_session

  def new
    session[:user_registration_return_to] ||= '/admin'
    super
  end

  private

  def set_devise_session
    if !params["k"].blank? && !params["p"].blank? && !params["u"].blank?
      session[:current_widget_host] = params["u"]
      session[:current_widget_key] = params["k"]
      session[:current_page] = params["p"]
      session["user_registration_return_to"] = "/close?" + "&p=#{params[:p]}&u=#{session[:current_widget_host]}&k=#{params[:k]}"
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if session[:current_page] && (!request.referer.include?('/admin') && !request.referer.include?('/admin/signup'))
      request.referer + "&p=#{session[:current_page]}&u=#{session[:current_widget_host]}&k=#{session[:current_widget_key]}"
    else
      request.referer
    end

  end

end