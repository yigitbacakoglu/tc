class Rating < ActiveRecord::Base
  belongs_to :ip_address
  belongs_to :ratable, :polymorphic => true
  #belongs_to :category
  attr_accessible :value, :ratable, :ratable_id, :ratable_type, :ip_address_id

  def max_value
    self.ratable.rating_category.max_value
  end

end
