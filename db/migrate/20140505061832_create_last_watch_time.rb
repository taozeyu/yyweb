class CreateLastWatchTime < ActiveRecord::Migration
  def self.up
    add_index "post_attentions", ["post_id", "user_id"]
    remove_index "post_praises", ["post_id", "user_id"]
    
  end

  def self.down
  end
end
