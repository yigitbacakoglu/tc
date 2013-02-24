class User < ActiveRecord::Base
  ROLES = %w[admin moderator author banned anonymous]

  attr_accessible :firstname, :lastname, :nickname, :role

  has_one :user_registration, :dependent => :destroy

  has_many :user_stores, :class_name => 'UserStore', :dependent => :destroy
  has_many :stores, :through => :user_stores
  has_many :restrictions, :as => :restrictable, :class_name => 'Restriction', :dependent => :destroy
  has_many :ip_addresses, :class_name => "IpAddress"
  has_many :comments, :class_name => 'Comment'

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def email
    self.user_registration.try(:email)
  end

  def fullname
    "#{firstname} #{lastname}"
  end

end
