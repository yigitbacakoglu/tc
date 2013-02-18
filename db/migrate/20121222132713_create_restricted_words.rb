class CreateRestrictedWords < ActiveRecord::Migration
  def change
    create_table :restricted_words do |t|
      t.integer :store_id
      t.text :value

      t.timestamps
    end
  end
end
