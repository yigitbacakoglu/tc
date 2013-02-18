class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :kind
      t.string :website
      t.string :email
      t.string :recover_email

      t.timestamps
    end
  end
end
