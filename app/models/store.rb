class Store < ActiveRecord::Base
  has_many :restrictions, :class_name => 'Restriction'
  has_many :restricted_words, :class_name => 'RestrictedWord'
  has_many :widgets, :class_name => 'Widget'
  has_many :user_stores, :class_name => 'UserStore'
  has_many :users, :through => :user_stores

  # Not banned users
  has_many :active_users,
           :through => :user_stores,
           :conditions => ["#{UserStore.quoted_table_name}.role != 'banned' OR #{UserStore.quoted_table_name}.role IS NULL"],
           :source => :user

  # Not banned users
  has_many :banned_users,
           :through => :user_stores,
           :conditions => ["#{UserStore.quoted_table_name}.role = 'banned'"],
           :source => :user


  has_many :comments
  attr_accessible :email, :kind, :name, :recover_email, :website


  def self.current=(store)
    Thread.current[:store] = store
  end

  def self.current
    Thread.current[:store]
  end
end
