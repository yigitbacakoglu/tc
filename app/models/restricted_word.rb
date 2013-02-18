class RestrictedWord < ActiveRecord::Base
  belongs_to :store
  attr_accessible :store_id, :value
end
