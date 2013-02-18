class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value
      t.references :ip_address
      t.integer :ratable_id
      t.string :ratable_type
      t.timestamps
    end
    add_index :ratings, :ip_address_id
    add_index :ratings, [:ratable_id, :ratable_type]
  end
end
