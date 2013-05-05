class UserRegistration < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  validate :check_user
  validate :check_password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  attr_accessor :login, :tmp_password
  attr_accessible :login
  belongs_to :user
  has_many :user_authentications, :class_name => 'UserAuthentication', :dependent => :destroy
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_attributes, :username, :user_id
  accepts_nested_attributes_for :user
  validates_presence_of :username
  validates_uniqueness_of :username
  after_create :deliver_password

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
    self.tmp_password = self.password
    self.user_authentications.build(:provider => omniauth['provider'],
                                    :uid => omniauth['uid'],
                                    :oauth_token => omniauth['credentials']['token'],
                                    :oauth_token_secret => omniauth['credentials']['secret'])
  end

  def check_user
    email = self.email.split(/@/)
    check_username(email[0])
    if self.user.blank?
      self.user = User.new(:firstname => self.username,
                           :lastname => email[1])
    end

  end

  def check_password
    if self.password.blank?
      self.password = Devise.friendly_token
      self.tmp_password = self.password
    end
  end


  def password_required?
    (user_authentications.empty? || !password.blank?) && super
  end

  def has_password?
    !self.encrypted_password.blank?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
    else
      where(conditions).first
    end
  end

  def check_username(nick)
    if self.username.blank?
      login_taken = UserRegistration.where(:username => nick).first
      unless login_taken
        self.username = nick
      else
        self.username = self.email
      end
    end
  end

  def deliver_password
    if self.tmp_password
      UserMailer.password(self.user, self.tmp_password).deliver
    end
  end

end


=begin
---- Categories ---

Blog
E-Commerce
News
Advertisement
Questionary
Personal Webpage

=end
