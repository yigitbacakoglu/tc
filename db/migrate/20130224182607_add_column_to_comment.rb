class AddColumnToComment < ActiveRecord::Migration
  def change
    add_column :comments, :user_agent, :string
    add_column :comments, :referer, :string
  end
end
