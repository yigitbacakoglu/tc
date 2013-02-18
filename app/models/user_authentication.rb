class UserAuthentication < ActiveRecord::Base
  attr_accessible :oauth_token, :oauth_token_secret, :provider, :uid

  belongs_to :user_registration

  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end

end
