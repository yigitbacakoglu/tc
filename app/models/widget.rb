class Widget < ActiveRecord::Base

  attr_accessible :category_id, :key, :store_id, :webpage, :login_required
  belongs_to :store
  has_many :posts, :class_name => "Post"

end
