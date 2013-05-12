class WidgetDomain < ActiveRecord::Base
  attr_accessible :domain, :widget_id
  belongs_to :widget
  before_save :remove_http
  validates :domain, :presence => true
  private

  def remove_http
    self.domain = self.domain.gsub('http://', '')
  end
end
