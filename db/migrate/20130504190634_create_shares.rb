class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :user_id
      t.string :provider
      t.string :source_type
      t.integer :source_id

      t.timestamps
    end
  end
end
