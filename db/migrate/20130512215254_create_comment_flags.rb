class CreateCommentFlags < ActiveRecord::Migration
  def change
    create_table :comment_flags do |t|
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
