class UserStore < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :role

  belongs_to :user
  belongs_to :store
  after_save :restrict_user

  scope :active, lambda { where("#{UserStore.quoted_table_name}.role != 'banned' OR #{UserStore.quoted_table_name}.role IS NULL") }

  def ban!
    self.update_attributes(:role => "banned")
  end

  def allow!
    self.update_attributes(:role => "active")
  end

  private

  def restrict_user
    if self.role_changed?
      if self.role.eql?('banned')
        rest = self.store.restrictions.new
        rest.restrictable = self.user
        rest.save
      else
        self.store.restrictions.collect { |r| (r.destroy if (r.restrictable == self.user)) }
      end
    end
  end
end
