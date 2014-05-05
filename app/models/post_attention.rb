class PostAttention < ActiveRecord::Base

  belongs_to :post, :counter_cache => :attentions_count
  
  def self.refresh_watch_time(user)
    self.where(:user_id => user.id).update_all(:last_watch_time => Time.now)
  end
  
end
