class CreateNotificationLogs < ActiveRecord::Migration
  def self.up
    create_table :notification_logs, :force => :id do |t|
      t.integer "id", :limit => 64, :null => false
      t.integer "post_id", :limit => 64, :null => false
      t.integer "initiator_id", :limit => 64, :null => false
      t.integer "type", :null => false
      t.datetime "create_at"
    end
    
    add_index :notification_logs, [:post_id, :create_at]
    
    drop_table :notifications
  end

  def self.down
    drop_table :notification_logs
  end
end
