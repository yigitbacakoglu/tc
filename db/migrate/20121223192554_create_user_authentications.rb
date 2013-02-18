class CreateUserAuthentications < ActiveRecord::Migration
  def change
    create_table :user_authentications do |t|
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.string :oauth_token_secret
      t.integer :user_registration_id

      t.timestamps
    end
  end
end
