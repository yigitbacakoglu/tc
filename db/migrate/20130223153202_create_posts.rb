class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :url
      t.integer :widget_id
      t.integer :category_id

      t.timestamps
    end
  end
end
