# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091115203231) do

  create_table "article_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "article_category_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "published",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "atolls", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "associate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "island_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "islands", :force => true do |t|
    t.string   "name"
    t.integer  "atoll_id"
    t.integer  "island_category_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", :force => true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listing_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "description"
    t.integer  "listing_type_id"
    t.date     "expiry_date"
    t.integer  "quantity"
    t.float    "price"
    t.boolean  "sold",                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "measuring_system_id"
  end

  create_table "measuring_systems", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measuring_systems_products", :id => false, :force => true do |t|
    t.integer "measuring_system_id"
    t.integer "product_id"
  end

  create_table "messages", :force => true do |t|
    t.string   "msisdn"
    t.text     "message"
    t.boolean  "is_valid",     :default => false
    t.string   "sms_command"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_type", :default => 0,     :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "product_category_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",                            :null => false
    t.string   "password_salt",                               :null => false
    t.string   "persistence_token",                           :null => false
    t.string   "single_access_token",                         :null => false
    t.string   "perishable_token",                            :null => false
    t.string   "full_name",                                   :null => false
    t.string   "phone",                                       :null => false
    t.string   "address"
    t.string   "street"
    t.integer  "island_id"
    t.string   "country",             :default => "Maldives"
    t.boolean  "active",              :default => false,      :null => false
    t.boolean  "admin",               :default => false,      :null => false
    t.integer  "login_count",         :default => 0,          :null => false
    t.integer  "failed_login_count",  :default => 0,          :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
