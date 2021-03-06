class CommentPraiseController < ApplicationController

  def create
    
    if curr_user.nil?
      render :text => 'error'
      return
    end
    
    comment = Comment.find_by_id(params[:id].to_i)
    if comment.nil?
      render :text => 'error'
      return
    end
    
    cp = CommentPraise.create(
      :user_id => curr_user.id,
      :comment_id => comment.id,
      :create_at => Time.now
    )
    NotificationMessage.notify(comment.author, curr_user, comment, NotificationMessage::TypePraiseComment)
    
    render :text => cp.id.to_s
  end
  
  def destroy
    
    if curr_user.nil?
      render :text => 'error'
      return
    end
    
    record = CommentPraise.find_by_id(params[:id].to_i)
    if record.nil?
      return render :text => 'error'
    elsif record.user_id != curr_user.id
      return render :text => 'error'
    end
    
    record.destroy
    render :text => 'ok'
  end
  
end
