class Rating < ActiveRecord::Base
  has_one :ip_address
  belongs_to :ratable, :polymorphic => true
  attr_accessible :value, :ratable, :ratable_id, :ratable_type
end
