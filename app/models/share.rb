class Share < ActiveRecord::Base
  attr_accessible :provider, :source_id, :source_type, :user_id

  belongs_to :source, :polymorphic => true
  belongs_to :user

  def self.default_scope
    where(" ( #{Share.table_name}.source_type = 'Comment' AND #{Share.table_name}.source_id IN(?) ) OR ( #{Share.table_name}.source_type = 'Post' AND #{Share.table_name}.source_id IN(?) )", Store.current.comment_ids, Post.where(:widget_id => Store.current.widget_ids).map(&:id) ) if !Store.current.nil?
  end
end
