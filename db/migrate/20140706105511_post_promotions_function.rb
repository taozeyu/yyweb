class PostPromotionsFunction < ActiveRecord::Migration
  def self.up
    remove_index :posts, ["is_delete", "last_reply_at"]
    add_column :posts, :honor_state, :integer, :limit => 8, :null => false, :default => 400
    add_index :posts, ["is_delete", "honor_state", "last_reply_at"]
  end

  def self.down
  end
end
