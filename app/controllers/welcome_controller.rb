class WelcomeController < ApplicationController
  before_filter :set_session
  prepend_before_filter :set_widget

  #before_filter :authenticate_user_registration!

  private
  def set_widget
    #URI.parse(env["REQUEST_URI"])
    @current_widget = Widget.where(:key => 1, :webpage => request.host.gsub("www.", "")).first
  end

  def set_session
    session[:user_registration_return_to] = '/demo'
  end
end