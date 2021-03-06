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

ActiveRecord::Schema.define(:version => 20080809090711) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "excerpt"
    t.text     "body"
    t.boolean  "published",                     :default => true
    t.integer  "user_id",         :limit => 11
    t.string   "permalink",       :limit => 40
    t.datetime "published_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "formatting_type", :limit => 20, :default => "HTML"
  end

  add_index "articles", ["permalink"], :name => "index_articles_on_permalink", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "name",       :limit => 40
    t.string   "email",      :limit => 40
    t.string   "website",    :limit => 40
    t.text     "body"
    t.boolean  "approved",                 :default => false
    t.integer  "article_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",        :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["var"], :name => "index_settings_on_var", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :limit => 11
    t.integer  "taggable_id",   :limit => 11
    t.integer  "tagger_id",     :limit => 11
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "last_name",                 :limit => 40
    t.string   "time_zone"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
