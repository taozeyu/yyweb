class ChangeTypeName < ActiveRecord::Migration
  def self.up
    rename_column :notification_messages, :type, :notify_type
    rename_column :notification_logs, :type, :notify_type
  end

  def self.down
  end
end
