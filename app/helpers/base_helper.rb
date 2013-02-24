ActionView::Helpers

module BaseHelper
    # rating_for(@object)
    def rating_for(rateable_obj, options={})

      rateable_obj.ratings.build if rateable_obj.ratings.blank?
      category = rateable_obj.rating_category

      rating_tool = category.name
      rating_max_value = category.max_value
      avg_rate = number_with_precision rateable_obj.avg_rate, :precision => 2

      content_tag :div, "", :class => "star", "data-rating" => avg_rate,
                  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                  "data-star-count" => rating_max_value, "data-url" => options[:url]
    end

end