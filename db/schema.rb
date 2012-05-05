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

ActiveRecord::Schema.define(:version => 20120505170827) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "pcategory"
    t.string   "scope"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["user_id"], :name => "index_categories_on_user_id"

  create_table "categories_routines", :id => false, :force => true do |t|
    t.integer "routine_id"
    t.integer "category_id"
  end

  add_index "categories_routines", ["category_id"], :name => "index_categories_routines_on_category_id"
  add_index "categories_routines", ["routine_id", "category_id"], :name => "index_categories_routines_on_routine_id_and_category_id", :unique => true
  add_index "categories_routines", ["routine_id"], :name => "index_categories_routines_on_routine_id"

  create_table "categories_works", :id => false, :force => true do |t|
    t.integer "work_id"
    t.integer "category_id"
  end

  add_index "categories_works", ["category_id"], :name => "index_categories_works_on_category_id"
  add_index "categories_works", ["work_id", "category_id"], :name => "index_categories_works_on_work_id_and_category_id", :unique => true
  add_index "categories_works", ["work_id"], :name => "index_categories_works_on_work_id"

  create_table "routines", :force => true do |t|
    t.integer  "user_id"
    t.string   "from"
    t.string   "to"
    t.string   "description"
    t.string   "days"
    t.string   "weeks"
    t.string   "dates"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routines", ["user_id"], :name => "index_routines_on_user_id"

  create_table "sources", :force => true do |t|
    t.integer  "user_id"
    t.integer  "work_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["user_id"], :name => "index_sources_on_user_id"
  add_index "sources", ["work_id"], :name => "index_sources_on_work_id"

  create_table "sources_tags", :id => false, :force => true do |t|
    t.integer "source_id"
    t.integer "tag_id"
  end

  add_index "sources_tags", ["source_id", "tag_id"], :name => "index_sources_tags_on_source_id_and_tag_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["user_id"], :name => "index_tags_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "works", :force => true do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer  "duration"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "works", ["from"], :name => "index_works_on_from"
  add_index "works", ["user_id"], :name => "index_works_on_user_id"

end
