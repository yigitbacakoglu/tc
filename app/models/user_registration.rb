class UserRegistration < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :user
  has_many :user_authentications, :class_name => 'UserAuthentication', :dependent => :destroy
  attr_accessible :email, :password, :password_confirmation, :remember_me
  #before_save :check_user

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end


  def apply_omniauth(omniauth)
    if omniauth['provider'] == "facebook" && email.blank?
      self.email = omniauth['info']['email']
    end
    self.password = Devise.friendly_token
    self.user_authentications.build(:provider => omniauth['provider'],
                                    :uid => omniauth['uid'],
                                    :oauth_token => omniauth['credentials']['token'],
                                    :oauth_token_secret => omniauth['credentials']['secret'])
  end

  #def check_user
  #  if self.user.blank?
  #    ip = IpAddress.where(:value => self.current_sign_in_ip).first
  #   if !ip.blank?
  #     self.user = ip.user
  #   end
  #  end
  #end

  def password_required?
    (user_authentications.empty? || !password.blank?) && super
  end

end
