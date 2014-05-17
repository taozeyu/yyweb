class NotificationLog < ActiveRecord::Base
  
  def self.notify(post, initiator, target, type)
    self.connection.execute(
      "update users set notification_logs_num = notification_logs_num + 1 " +
      "where id in (select user_id from post_attentions where post_id = #{post.id} " +
      "and user_id != #{initiator.id})"
    )
    self.create(
      :post_id => post.id,
      :initiator_id => initiator.id,
      :notify_type => type,
      :target_id => target.id,
      :create_at => Time.now
    )
  end
  
  def self.copy_messages(user)
    
    user.notification_logs_num = 0
    user.save
    
    self.connection.execute(
      "insert into notification_messages (user_id, initiator_id, target_id, notify_type, create_at) " +
      "select distinct #{user.id} as user_id, logs.initiator_id, logs.target_id, logs.notify_type, logs.create_at " + 
      "from notification_logs logs, post_attentions atts "+
      "where logs.post_id = atts.post_id and logs.initiator_id != #{user.id} and " + 
      "atts.user_id = #{user.id} and logs.create_at > atts.last_watch_time"
    )
    PostAttention.refresh_watch_time(user)
  end
  
end
