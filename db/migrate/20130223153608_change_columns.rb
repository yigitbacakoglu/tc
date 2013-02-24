class ChangeColumns < ActiveRecord::Migration
  def up
    add_column :comments, :post_id, :integer
    remove_column :comments, :widget_id

    add_column :categories, :max_value, :integer
    add_column :categories, :category_type, :string

    add_column :posts, :rating_category_id, :integer
    add_column :posts, :commenting_category_id, :integer

    change_column :ip_addresses, :value, :string

  end

  def down
  end
end
