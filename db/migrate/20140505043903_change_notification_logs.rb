class ChangeNotificationLogs < ActiveRecord::Migration
  
  def self.up
    
    add_column :notification_logs, :target_id, :integer, :limit => 8, :null => false, :default => 1
    
    add_column :post_attentions, :last_watch_time, :datetime, :null => false, :default => Time.new
    add_column :users, :notification_logs_num, :integer, :null => false, :default => 0
    
    add_index "post_praises", ["post_id", "user_id"]
  end

  def self.down
  end
end
