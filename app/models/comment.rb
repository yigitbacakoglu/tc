class Comment < ActiveRecord::Base
  paginates_per 25

  include Rakismet::Model
  rakismet_attrs :author => proc { user.fullname },
                 :author_email => proc { user.email },
                 :user_ip => proc { ip_address },
                 :content => proc { message },
                 :referrer => proc { referer },
                 :user_agent => proc { user_agent }

  belongs_to :post
  belongs_to :user
  belongs_to :store
  belongs_to :parent, :class_name => "Comment"
  has_many :children, :class_name => "Comment", :foreign_key => :parent_id
  has_many :ratings, :as => :ratable, :class_name => 'Rating', :dependent => :destroy
  has_many :shares, :as => :source, :class_name => "Share", :dependent => :destroy

  attr_accessible :kind, :message,
                  :parent_id, :ip_address, :user_agent, :referer, :user_id, :state

  validates :message, :presence => true
  validates_length_of :message, :minimum => 2, :maximum => 650, :allow_blank => true
  validate :restrictions
  scope :main, lambda { where("parent_id IS NULL") }
  scope :sub, lambda { where("parent_id IS NOT NULL") }
  scope :approved, lambda { where(:state => 'approved') }
  scope :rejected, lambda { where(:state => 'rejected') }
  scope :waiting, lambda { where(:state => 'new') }

  before_create :save_rating
  after_create :after_create
  state_machine :state, :initial => :new do
    event :approve do
      transition :from => :new, :to => :approved
      transition :from => :rejected, :to => :approved
    end
    event :reject do
      transition :from => :new, :to => :rejected
      transition :from => :approved, :to => :rejected
    end
  end


  def self.default_scope
    where("#{Comment.table_name}.store_id = ?", Store.current.id) if Store.current.present?
  end

  #after_transition :on => :register, :do => :sent_registered_mail

  def rate(value, ip_address, user_id)
    if can_rate? ip_address
      UserStore.create(:user_id => user_id, :store_id => self.store_id, :role => 'author') if self.store.user_stores.where(:user_id => user_id).blank?
      r = ratings.find_or_initialize_by_user_id(user_id)
      r.value = value
      r.ip_address = ip_address
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
    self.ratings.blank? ? 0 : (self.ratings.map(&:percentage_value).sum.to_f / self.ratings.count)
  end

  def percentage_avg_rate
    avg_rate
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

  # Returns CSS color class for span views
  def state_color
    case state
      when 'rejected'
        "red"
      when 'approved'
        "green"
      when 'new'
        "orange"
    end
  end

  private
  def save_rating
    #self.ratings.build(:value => 0, :ip_address_id => ip_address_id)
  end

  def after_create
    auto_approve
    save_user_store
    send_reply_mail
  end

  def send_reply_mail
    if self.parent.present?
      begin
        post = self.post
        UserMailer.replied_comment(self.parent.user, post).deliver
      rescue
        puts "Error on reply mail"
      end
    end
  end

  def auto_approve
    self.approve unless self.post.approval_required?
  end

  def save_user_store
    self.user.stores << Store.current if Store.current && !self.user.stores.include?(Store.current)
  end

  #Validate restrictions
  def restrictions
    validate_user
    validate_restricted_words
  end

  def validate_user
    errors.add(:base, "You are not allowed to comment") if self.post.widget.store && self.post.widget.store.restrictions.map(&:restrictable).include?(self.user)
  end


  def validate_restricted_words
    bads = []
    # Gets list of badwords
    IO.foreach('lib/badwords.txt') do |line|
      bads << line.strip
    end
    #Gets list of store restricted words

    bads += self.post.widget.store.restricted_words.map(&:value)
    badex = /\b(#{bads.join('|')})\b/i

    #Replacing bad words with star
    self.message = self.message.gsub(badex, '[**]').gsub('[**][**]', '[**]')

  end

end
