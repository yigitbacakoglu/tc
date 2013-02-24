class Comment < ActiveRecord::Base
  belongs_to :post
  has_one :ip_address
  has_many :ratings, :as => :ratable, :class_name => 'Rating'

  attr_accessible :kind, :message, :parent_id
end
