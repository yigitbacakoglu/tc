class IpAddress < ActiveRecord::Base
  attr_accessible :user_id, :value

  belongs_to :user

  before_save :validate_user


  private

  def validate_user
    if self.user.blank?
      create_anonymous_user
    end
  end

  def create_anonymous_user
    self.user = User.create(:firstname => I18n.t("anonymous"),
                     :lastname => I18n.t("user"),
                     :nickname => "Guest"
                     #:role => "anonymous"
    )
  end
end
