class Widget < ActiveRecord::Base

  attr_accessible :category_id, :key, :store_id, :webpage, :login_required, :approval_required
  belongs_to :store
  belongs_to :category
  has_many :posts, :class_name => "Post"
   before_save :generate_key

  def self.default_scope
    if !Store.current.nil?
      where("#{Widget.table_name}.store_id = ?", Store.current.id)
    end

  end

  private

  def generate_key
    self.key = SecureRandom.hex(15)
  end

end
