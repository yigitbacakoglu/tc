class Post < ActiveRecord::Base
  attr_accessible :url, :widget_id, :category_id

  belongs_to :widget
  belongs_to :category
  has_many :ratings, :as => :ratable, :class_name => 'Rating'
  has_many :comments, :class_name => "Comment"

  belongs_to :rating_category,
             :class_name => "Category",
             :foreign_key => :rating_category_id

  belongs_to :commenting_category,
             :class_name => "Category",
             :foreign_key => :commenting_category_id


  before_create :set_defaults

  def rate(value, ip_address, user_id)
    if can_rate? ip_address
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
    is_sub_comment = options[:is_sub_comment]
    c = comments.new(:ip_address => options[:ip_address])
    c.message = message
    c.user_id = options[:user_id]
    c.user_agent = options[:user_agent]
    c.referer = options[:referer]
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

  private

  def set_defaults
    unless self.rating_category #|| self.commenting_category
      self.rating_category = Category.where(:category_type => "rating").first
    end
  end

end
