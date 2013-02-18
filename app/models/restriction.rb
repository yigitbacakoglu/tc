class Restriction < ActiveRecord::Base
  belongs_to :restrictable, :polymorphic => true
  belongs_to :store

  attr_accessible :store_id, :restrictable, :restictable_id, :restictable_type
end
