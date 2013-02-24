class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
