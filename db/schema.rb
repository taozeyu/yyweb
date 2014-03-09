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

ActiveRecord::Schema.define(:version => 20140304134541) do

  create_table "comment_praises", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "comment_id", :null => false
    t.datetime "create_at",  :null => false
  end

  add_index "comment_praises", ["user_id", "comment_id"], :name => "index_comment_praises_on_user_id_and_comment_id"

  create_table "comments", :force => true do |t|
    t.integer  "post_id",                      :null => false
    t.integer  "author_id",                    :null => false
    t.datetime "create_at",                    :null => false
    t.text     "content",                      :null => false
    t.integer  "praises_count", :default => 0, :null => false
  end

  add_index "comments", ["post_id", "create_at"], :name => "index_comments_on_post_id_and_create_at"

  create_table "home_page_posts", :force => true do |t|
    t.integer  "post_id",          :null => false
    t.datetime "set_home_page_at", :null => false
  end

  create_table "node_managers", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "node_id",        :null => false
    t.datetime "take_office_at", :null => false
  end

  create_table "nodes", :force => true do |t|
    t.string "name",                       :null => false
    t.text   "introduction",               :null => false
    t.string "path_name",    :limit => 30
  end

  create_table "notifications", :force => true do |t|
    t.integer "target_id",              :null => false
    t.integer "doer_id",                :null => false
    t.integer "user_id",                :null => false
    t.integer "type",      :limit => 8, :null => false
  end

  create_table "paragraphs", :force => true do |t|
    t.text    "source_text",                          :null => false
    t.integer "translated_text_count", :default => 0, :null => false
    t.integer "post_id",               :default => 0, :null => false
    t.integer "idx",                   :default => 0, :null => false
    t.integer "translated_text_id"
  end

  add_index "paragraphs", ["post_id", "idx"], :name => "index_paragraphs_on_post_id_and_idx"

  create_table "post_attentions", :force => true do |t|
    t.integer  "user_id",   :null => false
    t.integer  "post_id",   :null => false
    t.datetime "create_at", :null => false
  end

  add_index "post_attentions", ["user_id", "post_id"], :name => "index_post_attentions_on_user_id_and_post_id"

  create_table "post_praises", :force => true do |t|
    t.integer  "user_id",   :null => false
    t.integer  "post_id",   :null => false
    t.datetime "create_at", :null => false
  end

  add_index "post_praises", ["user_id", "post_id"], :name => "index_post_praises_on_user_id_and_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "author_id",                                                               :null => false
    t.integer  "node_id",                                                                 :null => false
    t.datetime "create_at",                                                               :null => false
    t.datetime "update_at",                                                               :null => false
    t.integer  "post_type",             :limit => 8,                                      :null => false
    t.integer  "state",                 :limit => 8,                                      :null => false
    t.boolean  "is_elite",                                                                :null => false
    t.string   "title",                 :limit => 120,                                    :null => false
    t.text     "content",                                                                 :null => false
    t.integer  "attentions_count",                     :default => 0,                     :null => false
    t.integer  "praises_count",                        :default => 0,                     :null => false
    t.integer  "comments_count",                       :default => 0,                     :null => false
    t.integer  "paragraphs_count",                     :default => 0,                     :null => false
    t.integer  "translated_text_count",                :default => 0,                     :null => false
    t.datetime "last_reply_at",                        :default => '2014-01-01 00:00:00', :null => false
    t.integer  "last_reply_user_id",                   :default => 0,                     :null => false
    t.boolean  "is_delete",                            :default => false,                 :null => false
  end

  add_index "posts", ["is_delete", "last_reply_at"], :name => "index_posts_on_is_delete_and_last_reply_at"
  add_index "posts", ["node_id", "is_delete", "last_reply_at"], :name => "index_posts_on_node_id_and_is_delete_and_last_reply_at"

  create_table "translated_text_votes", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.integer  "translated_text_id", :null => false
    t.datetime "create_at",          :null => false
  end

  add_index "translated_text_votes", ["user_id", "translated_text_id"], :name => "index_translated_text_votes_on_user_id_and_translated_text_id"

  create_table "translated_texts", :force => true do |t|
    t.integer  "paragraph_id",                :null => false
    t.integer  "author_id",                   :null => false
    t.datetime "create_at",                   :null => false
    t.text     "content",                     :null => false
    t.integer  "vote_count",   :default => 0, :null => false
  end

  add_index "translated_texts", ["paragraph_id", "vote_count"], :name => "index_translated_texts_on_paragraph_id_and_vote_count"

  create_table "users", :force => true do |t|
    t.string   "name",                :limit => 10,                 :null => false
    t.string   "email",               :limit => 100,                :null => false
    t.string   "password_store",      :limit => 64,                 :null => false
    t.string   "salt",                                              :null => false
    t.datetime "register_at",                                       :null => false
    t.datetime "last_login_at",                                     :null => false
    t.string   "icon"
    t.datetime "birthday"
    t.integer  "sex",                 :limit => 8
    t.text     "signature",           :limit => 255
    t.integer  "schedule",                                          :null => false
    t.integer  "group",                              :default => 0, :null => false
    t.integer  "notifications_count",                :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
