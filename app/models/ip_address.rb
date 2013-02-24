class IpAddress < ActiveRecord::Base
  attr_accessible :user_id, :value

  belongs_to :user
  has_many :comments, :class_name => 'Comment'
  has_many :ratings, :class_name => 'Rating'

  before_save :validate_user


  private

  def validate_user
    if self.user.blank?
      create_anonymous_user
    end
  end

  def create_anonymous_user
    self.user = User.create(:firstname => "Anonymous",
                     :lastname => "User",
                     :nickname => "Guest",
                     :role => "anonymous")
  end
end
