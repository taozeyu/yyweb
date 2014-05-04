class NotificationMessage < ActiveRecord::Base

  TypeAt = 1
  TypeVote = 2
  TypePraisePost = 3
  TypePraiseComment = 4
  
  def self.notify(user, initiator, target, type)
    return nil if user.id == initiator.id
    attributes = {
      :user_id => user.id,
      :initiator_id => initiator.id,
      :target_id => target.id,
      :notify_type => type
    }
    notify = self.where(attributes).first || self.new(attributes)
    notify.create_at = Time.now
    notify.save!
  end
  
  def self.find(user)
    buff = {}
    res = []
    self.where(:user_id => user.id).order('create_at DESC').each do |item|
      if item.notify_type == TypeAt
        res << {
          :ids => [item.id],
          :target_id => item.target_id,
          :notify_type => item.notify_type,
          :initiator_ids => [item.initiator_id]
        }
      else
        key = "#{item.target_id},#{item.notify_type}"
        buff[key] ||= {
          :target_id => item.target_id,
          :notify_type => item.notify_type,
          :ids => [], :initiator_ids => []
        }
        buff[key][:initiator_ids] << item.initiator_id
        buff[key][:ids] << item.id
      end
    end
    buff.sort.each do |key, item|
      res << item
    end
    return res
  end
  
  def self.count(user)
    self.where(:user_id => user.id).count
  end
  
end
