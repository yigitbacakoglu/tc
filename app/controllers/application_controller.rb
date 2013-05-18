class ApplicationController < ActionController::Base
  protect_from_forgery
  include BaseHelper
  layout "application"
  prepend_before_filter :set_current_user
  before_filter :check_sale
  before_filter :set_anonymous_user
  before_filter :set_user_session

  def set_user_session
    if !params["k"].blank? && !params["p"].blank? && !params["u"].blank?
      session["user_registration_return_to"] = "/close?" + "&p=#{params[:p]}&u=#{session[:current_widget_host]}&k=#{params[:k]}"
    elsif params[:close] == "false"
      session.delete "user_registration_return_to"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def set_current_user
    User.current = user_registration_signed_in? ? current_user_registration.user : nil
    @current_user = User.current
    save_ip_address
  end

  def set_current_store(store = nil)
    store = Store.where(:id => session[:store_id]).first if store.blank? && session[:store_id]
    Store.current = (store || current_user.try(:first_managable_store))
    @current_store = Store.current
  end

  def current_user
    @current_user || @current_anonymous_user
  end

  def set_anonymous_user
    @current_anonymous_user = User.find(session[:user_id]) if session[:user_id]
  end

  def save_ip_address
    if @current_user
      session.delete :user_id
      @current_user.ip_addresses.find_or_create_by_value(request.remote_ip)
    end
  end

  def check_sale
    for_sale = ["tinagold.com", "www.tinagold.com"]
    if for_sale.include?(request.host)
      redirect_to sale_path if (request.path != sale_path) && (save_contact_info_path != request.path)
    end
  end

end
