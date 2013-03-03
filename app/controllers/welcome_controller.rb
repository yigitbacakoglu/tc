class WelcomeController < ApplicationController
  before_filter :set_session
  #before_filter :authenticate_user_registration!


  def set_session
    session[:user_registration_return_to] = '/demo'
  end
end