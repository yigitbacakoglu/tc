class AddUserIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer
    Comment.reset_column_information
    Comment.update_all(:user_id => 1)
  end
end
