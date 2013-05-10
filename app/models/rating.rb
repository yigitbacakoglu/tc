class Rating < ActiveRecord::Base
  belongs_to :ratable, :polymorphic => true
  #belongs_to :category
  attr_accessible :value, :ratable, :ratable_id, :ratable_type, :ip_address, :user_id
  before_create :save_max_value


  def self.default_scope
    where(" ( #{Rating.table_name}.ratable_type = 'Comment' AND #{Rating.table_name}.ratable_id IN(?) ) OR ( #{Rating.table_name}.ratable_type = 'Post' AND #{Rating.table_name}.ratable_id IN(?) )", Store.current.comment_ids, Post.where(:widget_id => Store.current.widget_ids).map(&:id) ) if !Store.current.nil?
  end

  private

  def save_max_value
    self.max_value = self.ratable.rating_category.max_value
  end

end
