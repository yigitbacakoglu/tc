#!/bin/env ruby
# encoding: utf-8

%w[
Blog
E-Commerce
News
Advertisement
Questionary
Personal Webpage
].each do |category|
  Category.create(:category_type => "widget", :name => category)
end


#store = Store.new
#store.kind = "blog"
#store.email = "admin@talkycloud.com"
#store.recover_email = "admin@talkycloud.com"
#
#if Rails.env == "development"
#  widget = store.widgets.new(:key => "139bad6f20fd9e75bb0a0836259466", :webpage => "localhost")
#  store.website = "localhost"
#
#else
#  store.website = "talkycloud.com"
#  widget = store.widgets.new(:key => "139bad6f20fd9e75bb0a0836259466", :webpage => "talkycloud.com")
#end
#widget.category = Category.last
#widget.login_required = true
#widget.approval_required = true
#
#post = widget.posts.new(:url => "/demo")
#post.rating_category = Category.new(:max_value => 5,
#                                    :name => "star",
#                                    :category_type => "rating")
#store.save
#
#post = widget.posts.create(:url => "/demo-2", :category_id => 5)
#post.rating_category = Category.create(:max_value => 6,
#                                       :name => "star",
#                                       :category_type => "rating")
#post.save
#
#
#ur = UserRegistration.new
#ur.username = "yigit"
#ur.email = "admin@admin.com"
#ur.password = "123123"
#ur.password_confirmation = "123123"
#ur.user = User.new(:firstname => 'yigit', :lastname => 'yigit', :role => 'admin')
#ur.save
#ur.user.stores << store
#
#restriction = store.restrictions.new
#restriction.restrictable = User.new()
#restriction.save
#
#%w[disqus am sik beleş].each do |val|
#  store.restricted_words.create(:value => val)
#end

# SecureRandom.hex(10)
# Devise.friendly_token