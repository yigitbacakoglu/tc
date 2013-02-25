class AuthenticationsController < ApplicationController
  before_filter :set_session

  def index
    @authentications = current_user_registration.user_authentications if current_user_registration
  end

  def create
    omniauth = request.env["omniauth.auth"]
    auth_hash = request.env["omniauth.auth"]
    authentication = UserAuthentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.update_attributes(:oauth_token => omniauth['credentials']['token'], :oauth_token_secret => omniauth['credentials']['secret'])
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user_registration, authentication.user_registration)
    elsif @current_user
      current_user_registration.user_authentications.create!(:provider => omniauth['provider'],
                                                             :uid => omniauth['uid'],
                                                             :oauth_token => omniauth['credentials']['token'],
                                                             :oauth_token_secret => omniauth['credentials']['secret'])
      flash[:notice] = "Authentication successful."
      redirect_to "/admin"
    else
      user_registration = UserRegistration.new
      user_registration.apply_omniauth(omniauth)
      if auth_hash['provider'] == 'twitter'
        auth_hash = get_name_from_twitter(auth_hash)
      end

      user_registration.build_user(:firstname => auth_hash['info']['first_name'].try(:strip), :lastname => auth_hash['info']['last_name'])

      if user_registration.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user_registration, user_registration)
      else
        session[:omniauth] = auth_hash.except('extra')
        redirect_to new_user_registration_registration_url
      end
    end
  end

  def destroy
    @authentication = @current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  private
  def set_session
    session[:user_registration_return_to] ||= '/admin'
  end

  def get_name_from_twitter(auth_hash)
    name = auth_hash['info']['name'].titleize.split(' ') if auth_hash['info']['name']
    if name.length > 1
      auth_hash['info']['last_name'] = name.delete(name[name.length - 1])
      auth_hash['info']['first_name'] = ''
      name.each do |i|
        auth_hash['info']['first_name'].concat(" #{i}")
      end
    else
      auth_hash['info']['first_name'] = name[0]
    end
    auth_hash
  end


  protected

# This is necessary since Rails 3.0.4
# See https://github.com/intridea/omniauth/issues/185
# and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end

end
