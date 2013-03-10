class AddColumnToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :login_required, :boolean, :default => false
    add_column :user_registrations, :username, :string
  end
end
