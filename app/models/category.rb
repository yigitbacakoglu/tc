class Category < ActiveRecord::Base
  attr_accessible :name, :category_type, :max_value

  has_many :widgets, :class_name => "Widget"
  has_many :posts, :class_name => "Post"
  has_many :ratings, :class_name => "Rating"
end
