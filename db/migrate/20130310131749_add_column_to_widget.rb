class AddColumnToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :login_required, :boolean, :default => false
    add_column :user_registrations, :username, :string

    add_column :ratings, :ip_address, :string
    add_column :comments, :ip_address, :string

    remove_column :ratings, :ip_address_id
    remove_column :comments, :ip_address_id
  end
end
