class CreateIpAddresses < ActiveRecord::Migration
  def change
    create_table :ip_addresses do |t|
      t.float :value
      t.integer :user_id

      t.timestamps
    end
  end
end
