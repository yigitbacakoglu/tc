require 'mechanize'
class Post < ActiveRecord::Base
  attr_accessible :url, :widget_id, :category_id, :title

  belongs_to :widget
  belongs_to :category
  has_many :ratings, :as => :ratable, :class_name => 'Rating'

  has_many :comments, :class_name => "Comment"

  has_many :approved_comments, :class_name => "Comment",
           :conditions => ["#{::Comment.quoted_table_name}.state = ? ", "approved"]

  belongs_to :rating_category,
             :class_name => "Category",
             :foreign_key => :rating_category_id

  belongs_to :commenting_category,
             :class_name => "Category",
             :foreign_key => :commenting_category_id

  has_many :shares, :as => :source, :class_name => "Share"

  before_create :set_defaults


  def approval_required?
    self.widget.approval_required?
  end


  def rate(value, ip_address, user_id)
    if can_rate? ip_address
      save_user_store(user_id)
      #r = ratings.find_or_initialize_by_ip_address_id(IpAddress.find_by_value(ip_address).id)
      r = ratings.find_or_initialize_by_user_id(user_id)
      r.value = value
      r.ip_address = ip_address
      r.save!
    else
      errors.add :base, "You already rated this."
      false
    end
  end

  def comment(message, options = {})
    parent_id = nil
    save_user_store(options[:user_id])
    unless message.is_a? String
      parent_id = message[:parent_id]
      message = message[:message]
    end

    is_sub_comment = options[:is_sub_comment]
    c = comments.new(:ip_address => options[:ip_address])
    c.message = message
    c.parent_id = parent_id
    c.user_id = options[:user_id]
    c.user_agent = options[:user_agent]
    c.referer = options[:referer]
    c.store_id = self.widget.store_id
    if c.spam?
      false
    else
      c.save
      c
    end

  end

  def can_rate?(ip_address)
    if User.current
      all_ratings = self.ratings.where(:user_id => User.current.id)
    else
      all_ratings = self.ratings.where(:ip_address => ip_address)
    end
    if all_ratings.blank?
      true
    else
      # Can change his rating within 5 mins.
      (all_ratings.order("updated_at desc").first.created_at.to_time + 300) >= Time.now
    end
  end

  def avg_rate
    self.ratings.blank? ? 0 : (self.ratings.map(&:value).sum.to_f / self.ratings.count)
  end

  def webpage
    "http://#{self.widget.webpage}#{self.url}"
  end

  def set_page_title
    begin
      agent = Mechanize.new
      page = agent.get(self.webpage)
      self.title = page.title
    rescue
      self.title = 'Join discussion here'
    end
  end

  def save_user_store(user_id)
    UserStore.create(:user_id => user_id, :store_id => self.widget.store_id, :role => 'author') if self.widget.store.user_stores.where(:user_id => user_id).blank?
  end

  private

  def set_defaults
    unless self.rating_category #|| self.commenting_category
      self.rating_category = Category.where(:category_type => "rating").first
    end
    set_page_title
  end

end
