class Comment < ActiveRecord::Base
  paginates_per 25

  include Rakismet::Model
  rakismet_attrs :author => proc { ip_address.user.fullname },
                 :author_email => proc { ip_address.user.email },
                 :user_ip => proc { ip_address.value },
                 :content => proc { message },
                 :referrer => proc { referer },
                 :user_agent => proc { user_agent }

  belongs_to :post
  belongs_to :ip_address
  belongs_to :user
  has_many :ratings, :as => :ratable, :class_name => 'Rating'

  attr_accessible :kind, :message, :parent_id, :ip_address_id, :user_agent, :referer, :user_id

  validates :message, :presence => true
  scope :main, lambda { where("parent_id IS NULL") }
  scope :sub, lambda { where("parent_id IS NOT NULL") }

  before_create :save_rating

  def rate(value, ip_address, user_id)
    if can_rate? ip_address
      #r = ratings.find_or_initialize_by_ip_address_id(IpAddress.find_by_value(ip_address).id)
      r = ratings.find_or_initialize_by_user_id(user_id)
      r.value = value
      r.ip_address_id = IpAddress.find_by_value(ip_address).id
      r.save!
    else
      errors.add :base, "You already rated this."
      false
    end
  end

  def rating_category
    post.rating_category
  end

  def avg_rate
    self.ratings.blank? ? 0 : (self.ratings.map(&:value).sum.to_f / self.ratings.count)
  end

  def can_rate?(ip_address)
    if User.current
      all_ratings = self.ratings.where(:user_id => User.current.id)
    else
      user_ips = IpAddress.find_by_value(ip_address).user.ip_address_ids
      all_ratings = self.ratings.where("ip_address_id IN(?)", user_ips)
    end
    if all_ratings.blank?
      true
    else
      # Can change his rating within 5 mins.
      (all_ratings.order("updated_at desc").first.created_at.to_time + 300) >= Time.now
    end
  end

  def save_rating
    #self.ratings.build(:value => 0, :ip_address_id => ip_address_id)
  end
end
