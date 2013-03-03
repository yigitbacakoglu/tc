DynamicSitemaps::Sitemap.draw do

  # default page size is 50.000 which is the specified maximum at http://sitemaps.org.
  per_page 10

  url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1

  new_page!

  url demo_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
  url demo2_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
  url demo3_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
  url sale_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 0.8

  #Widget.all.each do |widget|
  #  url widget_url(widget), :last_mod => widget.updated_at, :change_freq => 'daily', :priority => 0.8
  #end

  #new_page!

  #autogenerate  :widgets, :posts, :comments,
  #              :last_mod => :updated_at,
  #              :change_freq => 'daily',
  #              :priority => 0.8

  #new_page!
  #
  #autogenerate  :users,
  #              :last_mod => :updated_at,
  #              :change_freq => lambda { |user| user.very_active? ? 'weekly' : 'monthly' },
  #              :priority => 0.5

end