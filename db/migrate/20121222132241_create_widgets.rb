class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :store_id
      t.string :webpage
      t.integer :category_id
      t.string :key

      t.timestamps
    end
  end
end
