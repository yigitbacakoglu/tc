class Widget < ActiveRecord::Base

  attr_accessible :category_id, :key, :store_id, :webpage, :login_required, :approval_required, :widget_domains_attributes
  belongs_to :store
  belongs_to :category
  has_many :posts, :class_name => "Post"
  has_many :widget_domains, :class_name => "WidgetDomain"
  before_create :generate_key
  accepts_nested_attributes_for :widget_domains

  def self.default_scope
    if !Store.current.nil?
      where("#{Widget.table_name}.store_id = ?", Store.current.id)
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
  end

end
