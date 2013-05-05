class AddColumnToUserStore < ActiveRecord::Migration
  def change
    add_column :user_stores, :status, :string
  end
end
