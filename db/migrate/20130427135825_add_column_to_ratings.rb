class AddColumnToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :max_value, :integer

    Rating.all.each do |rating|
      begin
        max_val = rating.ratable.rating_category.max_value
        rating.update_attribute("max_value", max_val)
      rescue
        rating.destroy
      end
    end
  end
end
