class Store < ActiveRecord::Base
  has_many :restrictions, :class_name => 'Restriction'
  has_many :restricted_words, :class_name => 'RestrictedWord'
  has_many :widgets, :class_name => 'Widget'
  has_many :user_stores, :class_name => 'UserStore'
  has_many :users, :through => :user_stores

  # Not banned users
  has_many :active_users,
           :through => :user_stores,
           :conditions => ["#{UserStore.quoted_table_name}.status != 'banned' OR #{UserStore.quoted_table_name}.status IS NULL"],
           :source => :user

  # Not banned users
  has_many :banned_users,
           :through => :user_stores,
           :conditions => ["#{UserStore.quoted_table_name}.status = 'banned'"],
           :source => :user

  validates :name, :presence => true
  has_many :comments
  attr_accessible :email, :kind, :name, :recover_email, :website, :restricted_words_attributes, :phone
  accepts_nested_attributes_for :restricted_words

  # Adding restricted_words
  def add_words(word_array = [])
    word_array = [word_array] if word_array.is_a? String
    word_array.each do |word|
      self.restricted_words.create(:value => word)
    end
  end

  # Deleting restricted words
  def delete_words(word_array = [])
    word_array = [word_array] if word_array.is_a? String
    word_array.each do |word|
      self.restricted_words.where(:value => word).delete_all
    end
  end

  def self.current=(store)
    Thread.current[:store] = store
  end

  def self.current
    Thread.current[:store]
  end
end


# TODO We should add role to user_stores table.