class ChangeUserTable < ActiveRecord::Migration
  def change
    rename_column :restrictions, :restirctable_id, :restrictable_id
  end
end
