class UserRegistrationsController < Devise::RegistrationsController
  layout  "login"
  def create
    super
    session[:omniauth] = nil unless @user_registration.new_record?
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      auth_hash = session[:omniauth]
      @user_registration.apply_omniauth(session[:omniauth])
      @user_registration.build_user(:firstname => auth_hash['info']['first_name'].try(:strip), :lastname => auth_hash['info']['last_name'])
      @user_registration.valid?
    end
  end
end
