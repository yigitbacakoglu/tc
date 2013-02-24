class Widget < ActiveRecord::Base
  attr_accessible :category_id, :key, :store_id, :webpage

  belongs_to :store
  #has_many :ratings, :as => :ratable, :class_name => 'Rating'
  #has_many :comments, :class_name => "Comment"
  has_many :posts, :class_name => "Post"
end
