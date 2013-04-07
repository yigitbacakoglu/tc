class AddColumnToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :approval_required, :boolean, :default => false
  end
end
