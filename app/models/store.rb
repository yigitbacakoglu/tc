class Store < ActiveRecord::Base
  has_many :restrictions, :class_name => 'Restriction'
  has_many :restricted_words, :class_name => 'RestrictedWord'
  has_many :widgets, :class_name => 'Widget'
  has_many :user_stores, :class_name => 'UserStore'
  has_many :users, :through => :user_stores
  attr_accessible :email, :kind, :name, :recover_email, :website
end
