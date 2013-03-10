# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130310131749) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "max_value"
    t.string   "category_type"
  end

  create_table "comments", :force => true do |t|
    t.text     "message"
    t.integer  "ip_address_id"
    t.string   "kind"
    t.integer  "parent_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "post_id"
    t.string   "user_agent"
    t.string   "referer"
    t.integer  "user_id"
  end

  add_index "comments", ["ip_address_id"], :name => "index_comments_on_ip_address_id"

  create_table "ip_addresses", :force => true do |t|
    t.string   "value"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "url"
    t.integer  "widget_id"
    t.integer  "category_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "rating_category_id"
    t.integer  "commenting_category_id"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "value"
    t.integer  "ip_address_id"
    t.integer  "ratable_id"
    t.string   "ratable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
  end

  add_index "ratings", ["ip_address_id"], :name => "index_ratings_on_ip_address_id"
  add_index "ratings", ["ratable_id", "ratable_type"], :name => "index_ratings_on_ratable_id_and_ratable_type"

  create_table "restricted_words", :force => true do |t|
    t.integer  "store_id"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "restrictions", :force => true do |t|
    t.integer  "store_id"
    t.integer  "restirctable_id"
    t.string   "restrictable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "restrictions", ["restirctable_id", "restrictable_type"], :name => "index_restrictions_on_restirctable_id_and_restrictable_type"

  create_table "sales", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.string   "website"
    t.string   "email"
    t.string   "recover_email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_authentications", :force => true do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.string   "oauth_token_secret"
    t.integer  "user_registration_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "user_registrations", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "user_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
  end

  add_index "user_registrations", ["email"], :name => "index_user_registrations_on_email", :unique => true
  add_index "user_registrations", ["reset_password_token"], :name => "index_user_registrations_on_reset_password_token", :unique => true
  add_index "user_registrations", ["user_id"], :name => "index_user_registrations_on_user_id", :unique => true

  create_table "user_stores", :force => true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "nickname"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "widgets", :force => true do |t|
    t.integer  "store_id"
    t.string   "webpage"
    t.integer  "category_id"
    t.string   "key"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "login_required", :default => false
  end

end
