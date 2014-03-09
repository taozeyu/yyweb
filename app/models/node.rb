class Node < ActiveRecord::Base
  
  PerPage = 10 # how many posts per page.
  
  has_many :node_manager
  has_many :managers, :through => :node_manager, :source => :user
  has_many :posts, :foreign_key => :node_id
  
  def posts_list
    Post.where(:node_id => self.id, :is_delete => false)
      .select(Post::ColumnsExceptContent).order('last_reply_at desc')
  end
  
  def can_edit_introduction_by? (user)
    can_manager_by?(user)
  end
  
  def can_post_by? (user)
    return false if user.nil?
    return false unless user.can_post?
    #For now, every one can post in any node.
    return true
  end
  
  def can_manager_by? (user)
    return false if user.nil?
    if user.moderator?
      return NodeManager.where(:user_id => user.id, :node_id => self.id).any?
    elsif user.belongs_to_managers?
      return true
    end
    return false
  end
  
end
