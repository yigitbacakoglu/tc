class UserStore < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :status, :role

  belongs_to :user
  belongs_to :store
  before_save :set_role
  after_save :restrict_user

  scope :active, lambda { where("#{UserStore.quoted_table_name}.status != 'banned' OR #{UserStore.quoted_table_name}.status IS NULL") }

  def ban!
    self.update_attributes(:status => "banned")
  end

  def allow!
    self.update_attributes(:status => "active")
  end

  private

  def restrict_user
    if self.status_changed?
      if self.status.eql?('banned')
        rest = self.store.restrictions.new
        rest.restrictable = self.user
        rest.save
      else
        self.store.restrictions.collect { |r| (r.destroy if (r.restrictable == self.user)) }
      end
    end
  end

  def set_role
    self.role = 'author' if self.role.blank?
  end
end
