class Widget < ActiveRecord::Base

  attr_accessible :category_id, :key, :store_id, :webpage, :login_required, :approval_required
  belongs_to :store
  belongs_to :category
  has_many :posts, :class_name => "Post"




end
