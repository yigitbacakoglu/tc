class Rating < ActiveRecord::Base
  belongs_to :ratable, :polymorphic => true
  #belongs_to :category
  attr_accessible :value, :ratable, :ratable_id, :ratable_type, :ip_address, :user_id
  before_create :save_max_value
  after_save :notify_store

  def self.default_scope
    where(" ( #{Rating.table_name}.ratable_type = 'Comment' AND #{Rating.table_name}.ratable_id IN(?) ) OR ( #{Rating.table_name}.ratable_type = 'Post' AND #{Rating.table_name}.ratable_id IN(?) )", Store.current.comment_ids, Post.where(:widget_id => Store.current.widget_ids).map(&:id)) if !Store.current.nil?
  end

  def percentage_value
    (value / max_value)
  end

  private

  def save_max_value
    self.max_value = self.ratable.rating_category.max_value
  end

  def notify_store
    begin
      if  percentage_value < 0.3

        if self.ratable_type == 'Post'
          all_ratings = self.ratable.all_ratings
          post = self.ratable
          store = self.ratable.widget.store
        else
          all_ratings = self.ratable.post.all_ratings
          post = self.ratable.post
          store = self.ratable.store
        end
        array = all_ratings.order('updated_at DESC').limit(10).map(&:percentage_value)
        if ((array.sum.to_f / array.size) < 0.35)
          StoreMailer.bad_ratings(store, post).deliver
        end
      end
    rescue
      puts "Notify Store broken"
    end
  end
end
