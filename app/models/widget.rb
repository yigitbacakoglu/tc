class Widget < ActiveRecord::Base

  attr_accessible :category_id, :key, :store_id, :webpage, :login_required, :approval_required, :widget_domains_attributes,
                  :rating_category_id
  belongs_to :store
  belongs_to :category
  belongs_to :rating_category,
             :class_name => "Category",
             :foreign_key => :rating_category_id

  has_many :posts, :class_name => "Post"
  has_many :widget_domains, :class_name => "WidgetDomain"
  before_create :generate_key
  accepts_nested_attributes_for :widget_domains
  after_save :update_rating_tool

  def self.default_scope
    unless User.current.try(:system_admin?)
      where("#{Widget.table_name}.store_id = ?", Store.current.id) if !Store.current.nil?
    end

  end

  def name
    self.store.name
  end

  def domains
    self.widget_domains.map(&:domain)
  end

  private

  def generate_key
    self.key = SecureRandom.hex(15)
    self.rating_category = Category.rating.first
  end

  def update_rating_tool
    if self.rating_category_id_changed?
      self.posts.update_all(:rating_category_id => rating_category_id)
    end
  end

end
