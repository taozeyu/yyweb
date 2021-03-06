class CreateIndex < ActiveRecord::Migration
  def self.up
    # for users table
    add_index :users, :name, :unique => { :case_sensitive => false }
    add_index :users, :email, :unique => { :case_sensitive => false }
    
    # for posts table
    add_index :posts, [:is_delete, :last_reply_at]
    add_index :posts, [:node_id, :is_delete, :last_reply_at]
    
    # for comments table
    add_index :comments, [:post_id, :create_at]
    
    # for paragraphs table
    add_index :paragraphs, [:post_id, :idx]
    
    # for translated_texts table
    add_index :translated_texts, [:paragraph_id, :vote_count]
    
    # for post_attentions table
    add_index :post_attentions, [:user_id, :post_id]
    
    # for post_praises table
    add_index :post_praises, [:user_id, :post_id]
    
    # for translated_text_votes table
    add_index :translated_text_votes, [:user_id, :translated_text_id]
    
    # for comment_praises table
    add_index :comment_praises, [:user_id, :comment_id]
  end

  def self.down
  end
end
