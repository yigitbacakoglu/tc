class AddColumnRatingCategoryIdToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :rating_category_id, :integer
  end
end
