class CreateWidgetDomains < ActiveRecord::Migration
  def change
    create_table :widget_domains do |t|
      t.string :domain
      t.integer :widget_id

      t.timestamps
    end
  end
end
