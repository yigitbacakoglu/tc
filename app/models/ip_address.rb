class IpAddress < ActiveRecord::Base
  attr_accessible :user_id, :value

  belongs_to :user
  has_many :comments, :class_name => 'Comment'
  has_many :ratings, :class_name => 'Rating'
end
