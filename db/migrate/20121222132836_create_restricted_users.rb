class CreateRestrictedUsers < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.integer :store_id
      t.integer :restirctable_id
      t.string  :restrictable_type

      t.timestamps
    end
    add_index :restrictions, [:restirctable_id, :restrictable_type]
  end
end
