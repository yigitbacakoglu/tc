class AddStoreIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :store_id, :integer
  end
end
