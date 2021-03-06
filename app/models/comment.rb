class Comment < ActiveRecord::Base
  
  PerPage = 10
  
  has_many :comment_praise, :dependent => :destroy
  
  belongs_to :post, :counter_cache => :comments_count
  belongs_to :author, :foreign_key => :author_id, :class_name => "User"
  
  validates :content, :presence => true,
                   :length => {:minimum => 1, :maximum => 500}
                   
  def praise_id_by(user)
    return nil if user.nil?
    praise = CommentPraise.where(:comment_id => self.id, :user_id => user.id).first
    if praise.nil?
      return nil
    else
      return praise.id
    end
  end
  
end
