class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.string :provider
      t.string :api_key
      t.string :api_secret
      t.string :permission
      t.string :environment
      t.boolean :active

      t.timestamps
    end
  end
end
