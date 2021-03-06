class CreateTable < ActiveRecord::Migration
  def self.up

  create_table "comment_praises", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "user_id",    :limit => 64, :null => false
    t.integer  "comment_id", :limit => 64, :null => false
    t.datetime "create_at",                :null => false
  end
  
  create_table "comments", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "post_id",       :limit => 64,                 :null => false
    t.integer  "author_id",     :limit => 64,                 :null => false
    t.datetime "create_at",                                   :null => false
    t.text     "content",       :limit => 500,                :null => false
    t.integer  "praises_count",                :default => 0, :null => false
  end

  create_table "home_page_posts", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "post_id",          :limit => 64, :null => false
    t.datetime "set_home_page_at",              :null => false
  end

  create_table "node_managers", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "user_id",        :limit => 64, :null => false
    t.integer  "node_id",        :limit => 64, :null => false
    t.datetime "take_office_at",               :null => false
  end

  create_table "nodes", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.string "name",                       :null => false
    t.text   "introduction",               :null => false
    t.string "path_name",    :limit => 30
  end

  create_table "notifications", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer "target_id", :limit => 64, :null => false
    t.integer "doer_id",   :limit => 64, :null => false
    t.integer "user_id",   :limit => 64, :null => false
    t.integer "type",      :limit => 8,  :null => false
  end

  create_table "paragraphs", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.text    "source_text",           :limit => 1000,                :null => false
    t.integer "translated_text_count",                 :default => 0, :null => false
    t.integer "post_id",               :limit => 64,   :default => 0, :null => false
    t.integer "idx",                                   :default => 0, :null => false
    t.integer "translated_text_id",    :limit => 64
  end

  create_table "post_attentions", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "user_id",   :limit => 64, :null => false
    t.integer  "post_id",   :limit => 64, :null => false
    t.datetime "create_at",               :null => false
  end

  create_table "post_praises", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "user_id",   :limit => 64, :null => false
    t.integer  "post_id",   :limit => 64, :null => false
    t.datetime "create_at",               :null => false
  end

  create_table "posts", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "author_id",             :limit => 64,                                      :null => false
    t.integer  "node_id",               :limit => 64,                                      :null => false
    t.datetime "create_at",                                                                :null => false
    t.datetime "update_at",                                                                :null => false
    t.integer  "post_type",             :limit => 8,                                       :null => false
    t.integer  "state",                 :limit => 8,                                       :null => false
    t.boolean  "is_elite",                                                                 :null => false
    t.string   "title",                 :limit => 40,                                      :null => false
    t.text     "content",               :limit => 2000,                                    :null => false
    t.integer  "attentions_count",                      :default => 0,                     :null => false
    t.integer  "praises_count",                         :default => 0,                     :null => false
    t.integer  "comments_count",                        :default => 0,                     :null => false
    t.integer  "paragraphs_count",                      :default => 0,                     :null => false
    t.integer  "translated_text_count",                 :default => 0,                     :null => false
    t.datetime "last_reply_at",                         :default => '2014-01-01 00:00:00', :null => false
    t.integer  "last_reply_user_id",    :limit => 64,   :default => 0,                     :null => false
    t.boolean  "is_delete",                             :default => false,                 :null => false
  end

  create_table "translated_text_votes", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "user_id",            :limit => 64, :null => false
    t.integer  "translated_text_id", :limit => 64, :null => false
    t.datetime "create_at",                        :null => false
  end

  create_table "translated_texts", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.integer  "paragraph_id", :limit => 64,                  :null => false
    t.integer  "author_id",    :limit => 64,                  :null => false
    t.datetime "create_at",                                   :null => false
    t.text     "content",      :limit => 1000,                :null => false
    t.integer  "vote_count",                   :default => 0, :null => false
  end

  create_table "users", :force => :id do |t|
    t.integer "id", :limit => 64, :null => false
    t.string   "name",                :limit => 10,                 :null => false
    t.string   "email",               :limit => 100,                :null => false
    t.string   "password_store",      :limit => 64,                 :null => false
    t.string   "salt",                                              :null => false
    t.datetime "register_at",                                       :null => false
    t.datetime "last_login_at",                                     :null => false
    t.string   "icon"
    t.datetime "birthday"
    t.integer  "sex",                 :limit => 8
    t.text     "signature",           :limit => 60
    t.integer  "schedule",                                          :null => false
    t.integer  "group",                              :default => 0, :null => false
    t.integer  "notifications_count",                :default => 0
  end
  end

  def self.down
    drop_table :comment_praises
    drop_table :comments
    drop_table :home_page_posts
    drop_table :node_managers
    drop_table :node
    drop_table :notifications
    drop_table :paragraphs
    drop_table :post_attentions
    drop_table :post_praises
    drop_table :posts
    drop_table :translated_text_votes
    drop_table :translated_texts
    drop_table :users
  end
end
