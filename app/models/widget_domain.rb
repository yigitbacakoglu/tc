class WidgetDomain < ActiveRecord::Base
  attr_accessible :domain, :widget_id
  belongs_to :widget
end
