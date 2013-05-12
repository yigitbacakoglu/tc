class User < ActiveRecord::Base
  ROLES = %w[admin moderator author anonymous]

  attr_accessible :firstname, :lastname, :nickname, :gender, :user_registration_attributes

  has_one :user_registration, :dependent => :destroy
  has_many :shares, :class_name => "Share"
  has_many :user_authentications, :through => :user_registration
  after_commit :check_registration
  has_many :user_stores, :class_name => 'UserStore', :dependent => :destroy
  has_many :stores, :through => :user_stores
  has_many :restrictions, :as => :restrictable, :class_name => 'Restriction', :dependent => :destroy
  has_many :ip_addresses, :class_name => "IpAddress"
  has_many :comments, :class_name => 'Comment'
  has_many :ratings, :class_name => 'Rating'
  has_many :flags, :class_name => 'CommentFlag'
  before_create :create_bogus_store

  accepts_nested_attributes_for :user_registration

  def role=(param)
    _us = self.user_stores.where(:store_id => Store.current.try(:id)).first
    unless _us.blank?
      _us.update_attributes(:role => param)
    end
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def system_admin?
    ['yigitcan_bacakoglu@hotmail.com', "ycbacakoglu@gmail.com"].include? self.email
  end

  def first_managable_store
    managable_stores.first
  end

  def managable_stores
    user_stores.where(:role => 'admin').map(&:store).delete_if(&:blank?)
  end

  # Ready to use app ?
  def has_valid_store?
    !first_managable_store.blank? && first_managable_store.initial?
  end

  def banned_from?(store)
    self.user_stores.where(:store_id => store.id).first.status.eql?('banned') rescue false
  end

  def email
    self.user_registration.try(:email)
  end

  def username
    anonymous? ? 'Anonymous' : self.user_registration.username
  end

  def fullname
    "#{firstname} #{lastname}"
  end

  def anonymous?
    self.firstname.eql? "Anonymous"
  end

  def has_role?(param)
    self.role == param.try(:to_s)
  end

  def role
    self.user_stores.where(:store_id => Store.current.try(:id)).first.try(:role) || 'author'
  end

  def rating_avg_on(store)
    (comment_rating_avg_on(store) + post_rating_avg_on(store)) / 2
  end

  def comment_rating_avg_on(store)
    sum = 0
    rates = self.ratings.where("#{::Rating.quoted_table_name}.ratable_type = ? AND #{::Rating.quoted_table_name}.ratable_id IN(?)", "Comment", store.comment_ids)
    rates.collect { |r| sum += (100*(r.value / r.max_value)) }
    rates.blank? ? 0 : (sum / rates.count)
  end

  def post_rating_avg_on(store)
    sum = 0
    rates = self.ratings.where("#{::Rating.quoted_table_name}.ratable_type = ? AND #{::Rating.quoted_table_name}.ratable_id IN(?)", "Post", store.widgets.map(&:post_ids).first)
    rates.collect { |r| sum += (100*(r.value / r.max_value)) }
    rates.blank? ? 0 : (sum / rates.count)
  end

  private
  def check_registration
    if self.user_registration.blank?
      user_registration = UserRegistration.new(:email => "#{SecureRandom.hex(20)}@example.com", :user_id => self.id)
      user_registration.user = self
      user_registration.save
    end
  end

  def create_bogus_store
    store = self.stores.new
    store = Store.new
    store.kind = "blog"
    store.name = "Bogus"
    store.email = "admin@talkycloud.com"
    store.recover_email = "admin@talkycloud.com"
    store.website = "talkycloud.com"
  end
end
