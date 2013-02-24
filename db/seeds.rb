widget = Widget.create(:key => 1, :webpage => "localhost")
post = widget.posts.create(:url => "/demo")
post.rating_category = Category.create(:max_value => 5,
                                       :name => "star",
                                       :category_type => "rating")
post.save

post = widget.posts.create(:url => "/demo-2")
post.rating_category = Category.create(:max_value => 6,
                                       :name => "star",
                                       :category_type => "rating")
post.save
