class UserPasswordsController < Devise::PasswordsController
  layout "login"

  def update
    session["user_registration_return_to"] = '/admin'
    super
  end
end
