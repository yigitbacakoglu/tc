class AddRoleToUserStore < ActiveRecord::Migration
  def change
    add_column :user_stores, :role, :string
  end
end
