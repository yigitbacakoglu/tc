class Category < ActiveRecord::Base
  attr_accessible :name, :category_type, :max_value

  has_many :widgets, :class_name => "Widget"
  has_many :posts, :class_name => "Post"
  has_many :ratings, :class_name => "Rating"


  def symbol
    case name
      when "thumb"
        "<i class='icon-hand-up'></i>".html_safe
      when "star"
        "<i class='icon-star'></i>".html_safe
      when "vote"
        "<i class='icon-chevron-up'></i>".html_safe
      when "plus"
        "<i class='icon-plus'></i>".html_safe

    end
  end

  def self.rating_categories
    where(:category_type => 'rating')
  end
end
