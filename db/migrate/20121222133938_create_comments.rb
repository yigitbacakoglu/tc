class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :message
      t.references :widget
      t.references :ip_address
      t.string :kind
      t.integer :parent_id

      t.timestamps
    end
    add_index :comments, :widget_id
    add_index :comments, :ip_address_id
  end
end
